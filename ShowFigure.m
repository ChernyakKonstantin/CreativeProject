function ShowFigure(videoPlayer, framergb, tracker)
    if ~isempty(tracker.Bboxes)
        displayFrame = insertObjectAnnotation(framergb, 'rectangle',tracker.Bboxes, tracker.BoxIds);
        %displayFrame = insertMarker(displayFrame, tracker.Points);
        videoPlayer.step(displayFrame);
        tracker.BoxIds;
    else
        videoPlayer.step(framergb);
    end
end