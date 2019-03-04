function process_qa_data()
    config = jsondecode(fileread("../config/config.json"));

    INPUT_DIR = "" + config.process_qa_data.in_dir;
    OUTPUT_DIR = "" + config.process_qa_data.out_dir;
    INPUT_FILE_NAME = "" + config.process_qa_data.input_file_name;
    OUTPUT_FILE_NAME = "" + config.process_qa_data.output_file_name;
    
%   pre_process_qa_file()

    IN_CSV_FILE  = INPUT_DIR + INPUT_FILE_NAME;
    OUT_MAT_FILE = OUTPUT_DIR + OUTPUT_FILE_NAME;
    process_qa_csv_mat(IN_CSV_FILE, OUT_MAT_FILE);
    
end

% This function is to seperate the QA data to 2017-18
function pre_process_qa_file()
    disp("Seperating the 2017-18 data");
    IN_FILE  = "../data/in/QA_DATA_2016-18_u.csv";
    OUT_FILE = "../data/out/QA_DATA_2017-18.csv";
    
    startDate = '01/01/2017 00:00';
    endDate   = '01/01/2019 00:00';
    startDtNum = datenum(startDate, 'dd/mm/yyyy HH:MM');
    endDtNum = datenum(endDate, 'dd/mm/yyyy HH:MM');
    
    out_fd = fopen(OUT_FILE, 'w');
    
    csv_fd = fopen(IN_FILE);
    j = 1;
    line = fgetl(csv_fd);
    while ischar(line)
        data = strsplit(line, ",");
        if(length(data) == 8)
            dtNum = datenum(data(5), 'dd/mm/yyyy HH:MM:SSAM');
            if(dtNum >= startDtNum && dtNum < endDtNum) 
                data{5} = datestr(dtNum, 'dd/mm/yyyy HH:MM');
                all_str = sprintf('%s,', data{:});
                all_str = all_str(1:end-1);
                fprintf(out_fd, "%s\n", all_str);
            end
        else
            disp("Data anomaly found");
        end
        
        disp("Processing line " + j);
        j = j + 1;
        drawnow;
        line = fgetl(csv_fd);
    end
    fclose(csv_fd);
    fclose(out_fd);
end

%
% This function is to convert csv QA file to MAT file.
%
function process_qa_csv_mat(inFile, outFile)
    disp(inFile + " QA CSV data to MAT " + outFile);

    csv_fd = fopen(inFile);
    
    j = 1;
    mat_obj = [];
    test_data = [];
    
    reel_id = -1;
    date_time = '';
    grade_code = '';
    product_name = '';
    grammage = '';
    
    line = fgetl(csv_fd);
    while ischar(line)
        data = strsplit(line, ",");
        if(length(data) == 8)
            if(reel_id == -1)
                reel_id = data{1};
                date_time = data{5};
                grade_code = data{6};
                product_name = data{7};
                grammage = data{8};
                property_data = struct('Property_code', data{2}, 'Property_name', data{3}, 'value', data{4});
                test_data = [test_data; property_data];
            elseif(reel_id == data{1})
                if(date_time ~= data{5})
                    disp("datetime does not match!");
                    drawnow;
                    waitforbuttonpress;
                end
                
                if(grade_code ~= data{6})
                    disp("gradecode does not match!");
                    drawnow;
                    waitforbuttonpress;
                end
                
                if(product_name ~= data{7})
                    disp("product name does not match!");
                    drawnow;
                    waitforbuttonpress;
                end
                
                if(grammage ~= data{8})
                    disp("grammage does not match!");
                    drawnow;
                    waitforbuttonpress;
                end
                
                property_data = struct('Property_code', data{2}, 'Property_name', data{3}, 'value', data{4});
                test_data = [test_data; property_data];
            else
                tmp_obj = struct('reel_id', reel_id, 'date', date_time, 'property', test_data, 'grade_code', grade_code, 'product_name', product_name, 'grammage', grammage);
                mat_obj = [mat_obj; tmp_obj];
                test_data = [];
                
                reel_id = data{1};
                date_time = data{5};
                grade_code = data{6};
                product_name = data{7};
                grammage = data{8};

            end
        else
            disp("Data anomaly found");
        end
        
        disp("Processing line " + j);
        j = j + 1;
        drawnow;
        line = fgetl(csv_fd);
    end
    
    % This is for the last entry, because loop will end before entry the
    % data in the array.
    tmp_obj = struct('reel_id', reel_id, 'date', date_time, 'property', test_data, 'grade_code', grade_code, 'product_name', product_name, 'grammage', grammage);
    mat_obj = [mat_obj; tmp_obj];

    fclose(csv_fd);
    save(outFile, 'mat_obj');
    disp("Mat file saved successfully");
    drawnow;
end





