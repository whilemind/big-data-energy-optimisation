function process_csv_pd()
    config = jsondecode(fileread("../config/config.json"));
    
    INPUT_DIR = "" + config.process_csv_pd.in_dir;
    OUTPUT_DIR = "" + config.process_csv_pd.out_dir;
    INPUT_FILE_NAME = config.process_csv_pd.input_files;
    OUTPUT_FILE_NAME = "" + config.process_csv_pd.output_file_name;


    OUT_FILE = OUTPUT_DIR + OUTPUT_FILE_NAME;
    processData = [];
    for k = 1:length(INPUT_FILE_NAME)
        IN_FILE = INPUT_DIR + "" + INPUT_FILE_NAME(k);
        disp("Processing IN FILE " + IN_FILE);
        drawnow;
        csv_fd = fopen(IN_FILE);

        isHeader = false;
        line = fgetl(csv_fd);
        while ischar(line)
            if(isHeader) 
                data = strsplit(line, ",");
                [pdata.datetime, pdata.sensorData] = filter_PD(data);
                processData = [processData; pdata];
            else 
                isHeader = true;
            end

            line = fgetl(csv_fd);
        end
        fclose(csv_fd);
        disp("Saving mat for IN FILE " + IN_FILE);
        save(OUT_FILE, 'processData');
    end
end %end of function

