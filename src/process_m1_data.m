function process_m1_data()
    config = jsondecode(fileread("../config/config.json"));
    
    INPUT_DIR = "" + config.process_m1_data.in_dir;
    OUTPUT_DIR = "" + config.process_m1_data.out_dir;
    INPUT_FILE_NAME = config.process_m1_data.input_files;
    OUTPUT_FILE_NAME = "" + config.process_m1_data.output_file_name;
    
    OUT_FILE = OUTPUT_DIR + OUTPUT_FILE_NAME;
    processData_m1 = [];
    for k = 1:length(INPUT_FILE_NAME)
        IN_FILE = INPUT_DIR + "" + INPUT_FILE_NAME(k);
        disp("Processing IN FILE " + IN_FILE);
        drawnow;

        csv_fd = fopen(IN_FILE);

        i = 1;
        isHeader = false;
        line = fgetl(csv_fd);
        while ischar(line)
            if(isHeader) 
                data = strsplit(line, ",");
                [pdata.datetime, pdata.M1_energy] = filter_PD(data);
                processData_m1 = [processData_m1; pdata];
            else 
                isHeader = true;
            end
            disp("Processing line " + i);
            i = i + 1;
            drawnow;
            line = fgetl(csv_fd);
        end
        fclose(csv_fd);
        disp("Saving mat for IN FILE " + IN_FILE);
        save(OUT_FILE, 'processData_m1');
    end
end

