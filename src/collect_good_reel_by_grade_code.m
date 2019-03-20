function collect_good_reel_by_grade_code()
    config = jsondecode(fileread('../config/config.json'));
    
    INPUT_DIR = "" + config.good_reel_by_gradecode.out_dir;
    OUTPUT_DIR = "" + config.good_reel_by_gradecode.out_dir;
    INPUT_FILE_NAME = config.good_reel_by_gradecode.input_file_name;
    OUTPUT_FILE_NAME = "" + config.good_reel_by_gradecode.output_file_name;
    OUT_FILE = OUTPUT_DIR + OUTPUT_FILE_NAME;
    GRADE_CODE_FILE = "" + config.generate_gradecode.out_dir + config.generate_gradecode.output_file_name;
    BAD_REEL_FILE = "" + config.bad_reel.bad_reel_file;
    EXT = "" + config.good_reel_by_gradecode.ext;
    
    analysis = [];
    for i = 1:length(INPUT_FILE_NAME)
        tmp = load(INPUT_DIR + INPUT_FILE_NAME(i));
        analysis = [analysis; tmp.analysis];
    end
    
    grades = load(GRADE_CODE_FILE);
    badReel = load(BAD_REEL_FILE);
    for i = 1:length(grades.gradecode)
        grade_analysis = [];
        fprintf("GradeCode %d of %d .......................", i, length(grades.gradecode));
        drawnow;
        for j= 1:length(analysis)
            display_progress(j, config.logger.verbose);
            if(strcmp(grades.gradecode(i), analysis(j).qa_data.grade_code))
                if(~ismember(str2num(analysis(j).reel_id), badReel.M))
                    grade_analysis = [grade_analysis; analysis(j)];
                end
            end
        end
        fprintf("\n");
        saveFile = OUT_FILE + grades.gradecode(i) + EXT;
        disp("Saving File " + saveFile);
        drawnow;
        save(saveFile, 'grade_analysis');
    end
    
end