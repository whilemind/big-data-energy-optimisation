function compare_data()
    OLD_PD_FILE = "../data/out/ana/ANA_2017-18_Q_1-4_4.mat";
    NEW_PD_FILE = "../data/out/ana/ANA_BY_REEL_2017-18_Q_1-4_4.mat";
    
    disp("Loading old process data file " + OLD_PD_FILE);
    drawnow;
    tic;
    pd_data_old = load(OLD_PD_FILE);
    toc;

    disp("Loading new process data file " + NEW_PD_FILE);
    drawnow;
    tic;
    pd_data_new = load(NEW_PD_FILE);
    toc;
    
    count = 0;
    for i = 1:length(pd_data_new.analysis)
        newDataLen = length(pd_data_new.analysis(i).process_data_details.proc_data);
        oldDataLen = length(pd_data_old.analysis(i).process_data_details.proc_data);
        if(newDataLen == oldDataLen)
            continue;
        else
            count = count + 1;
            disp("Did not match. " + i);
            disp("Old reel " + pd_data_old.analysis(i).reel_id + " data length " + oldDataLen);
            disp("New reel " + pd_data_new.analysis(i).reel_id + " data length " + newDataLen);
            drawnow;
            if(newDataLen == 0)
                drawnow;
            end
        end
    end
    disp("Total mismatch found " + count);
    drawnow;
end