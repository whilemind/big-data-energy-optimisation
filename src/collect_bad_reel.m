function collect_bad_reel()
    config = jsondecode(fileread('../config/config.json'));
    
    INPUT_DIR = "" + config.analysis_data.out_dir;
    OUTPUT_DIR = "" + config.bad_reel.out_dir;
    INPUT_FILE_NAME = config.bad_reel.input_file_name;
    OUTPUT_FILE_NAME = "" + config.bad_reel.output_file_name;
    OUT_FILE = OUTPUT_DIR + OUTPUT_FILE_NAME;

    bad_reel_analysis = [];
    analysis = [];
    for i = 1:length(INPUT_FILE_NAME)
        tmp = load(INPUT_DIR + INPUT_FILE_NAME(i));
        analysis = [analysis; tmp.analysis];
    end
    
    badReel = load("" + config.bad_reel.bad_reel_file);
    for i = 1:length(badReel.M)
        for j= 1:length(analysis)
            if(badReel.M(i) == str2num(analysis(j).reel_id))
                bad_reel_analysis = [bad_reel_analysis; analysis(j)];
                break;
            end
        end
    end
    save(OUT_FILE, 'bad_reel_analysis');
    
end %end of function

