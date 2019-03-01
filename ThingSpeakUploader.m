function ThingSpeakUploader(tracker)
    %% Account data
    Channel_ID = 668624;
    Write_Key = 'TLOMDMY5FTI9XVU1';
    %%
    Pedestrians_In_Frame = numel(tracker.BoxIds);
    Total_Number = max(tracker.BoxIds);
    thingSpeakWrite(Channel_ID, [Pedestrians_In_Frame, Total_Number], 'WriteKey',Write_Key)
end
