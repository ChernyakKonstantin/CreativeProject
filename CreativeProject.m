%% Preparation
clear all;
clc;
close all;
delete(timerfindall);

%% Add video
Video = GetVideo();

%% Tools initialization
pedestriansDetector = peopleDetectorACF('caltech-50x21');
videoPlayer = vision.VideoPlayer;
videoFileReader = vision.VideoFileReader(Video);
tracker = MultiObjectTrackerKLT;

%% Check the latest count !? I think it isn't neccessary
%[] = thingSpeakRead(Channel_ID,'ReadKey',Read_Key)
%if dateshift(latestDate,'start','day') < datetime('today','TimeZone','local')
%    logThingSpeakData('reset')
%end
%if ~isempty(initialNum)
%    tracker.NextId  = initialNum(1) + 1;
%end

%% 
frameNumber = 0;
%% Timer creation
tim = timer;
tim.ExecutionMode = 'FixedRate';
tim.Period = 20;
tim.TimerFcn = @(x,y) ThingSpeakUploader(tracker);
tim.StartDelay = 5;
%% First search and add detection
bboxes = [];
while isempty(bboxes)
    framergb = videoFileReader();
    frame = rgb2gray(framergb);
    bboxes = detect(pedestriansDetector,frame);
end
tracker.addDetections(frame, bboxes);
start(tim);
%% Begin
while ~isDone(videoFileReader)
    framergb = videoFileReader();
    frame = rgb2gray(framergb);
    if mod(frameNumber, 10) == 1 %Ever 10th frame (re)detect pedestrians
        bboxes = detect(pedestriansDetector,frame);
        if ~isempty(bboxes)
            tracker.addDetections(frame, bboxes);
        end
    else
        tracker.track(frame); % Track people
    end
    
    ShowFigure(videoPlayer, framergb, tracker); %Show player b
    
    frameNumber = frameNumber + 1;
    
end

%% End
stop(tim);
release(videoPlayer);