function collect_good_reel_scale()
    config = jsondecode(fileread('../config/config.json'));
    GRADE_CODE_FILE = "" + config.generate_gradecode.out_dir + config.generate_gradecode.output_file_name;    
    OUT_FILE = "" + config.make_scale.out_dir + config.make_scale.output_file_name;
    verbose = config.logger.verbose;
    
    scale = [];
    grades = load(GRADE_CODE_FILE);
    for i = 1:length(grades.gradecode)
        inputfile = "" + config.good_reel_by_gradecode.out_dir + config.good_reel_by_gradecode.output_file_name + grades.gradecode(i) + config.good_reel_by_gradecode.ext;
        if exist(inputfile, 'file') == 2
            disp("Accessing grade code " + grades.gradecode(i));
            tmp = load(inputfile);
            grams = extractfield(tmp.grade_analysis, 'gram');
            uni_grams = unique(grams);
            for j = 1:length(uni_grams)
                analysis = [];
                fprintf("Progress lines %d of .......................", length(tmp.grade_analysis));
                for k = 1:length(tmp.grade_analysis)
                    display_progress(k, verbose);
                    if(tmp.grade_analysis(k).gram == uni_grams(j))
                        analysis = [analysis; tmp.grade_analysis(k)];
                    end
                end
                scale_data = struct('gradecode', grades.gradecode(i), 'gram', uni_grams(j));
                for k = 1:length(config.generate_factors.terms)
                    fieldNameMax = strcat(config.generate_factors.terms(k).name, '_max');
                    fieldNameMin = strcat(config.generate_factors.terms(k).name, '_min');
                    dataMax = extractfield(analysis, fieldNameMax);
                    dataMin = extractfield(analysis, fieldNameMin);
                    maxAvg = nanmean(dataMax);
                    minAvg = nanmean(dataMin);
                    
                    [scale_data(:).(fieldNameMax)] = maxAvg;
                    [scale_data(:).(fieldNameMin)] = minAvg;
                end
                scale = [scale; scale_data];
                fprintf("\n");
            end
            save(OUT_FILE, 'scale');
        else
             disp("File missing" + inputfile);
        end
    end
end