function generate_gradecode()
    config = jsondecode(fileread('../config/config.json'));

    INPUT_DIR = "" + config.generate_gradecode.in_dir;
    OUTPUT_DIR = "" + config.generate_gradecode.out_dir;
    INPUT_FILE_NAME = "" + config.generate_gradecode.input_file_name;
    OUTPUT_FILE_NAME = "" + config.generate_gradecode.output_file_name;
 
    IN_QA_FILE  = OUTPUT_DIR + INPUT_FILE_NAME;
    OUT_MAT_FILE = OUTPUT_DIR + OUTPUT_FILE_NAME;

    disp("Loading process data file " + IN_QA_FILE);
    drawnow;
    tic;
    qa_data = load(IN_QA_FILE);
    toc;
    
    gradecode = [];
%     all_gd = extractfield(qa_data.mat_obj, 'grade_code');
    all_gd = [qa_data.mat_obj.grade_code];
    gradecode = unique(all_gd);
   
    save(OUT_MAT_FILE, 'gradecode');
    disp("Output file " + OUT_MAT_FILE + " saved successfully.");
    drawnow;
end