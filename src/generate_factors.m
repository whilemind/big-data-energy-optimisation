
function generate_factors()
    config = jsondecode(fileread("../config/config.json"));

    INPUT_DIR = "" + config.generate_factors.in_dir;
    OUTPUT_DIR = "" + config.generate_factors.out_dir;
    INPUT_FILE_NAME = "" + config.generate_factors.input_file_name;
    OUTPUT_FILE_NAME = "" + config.generate_factors.output_file_name;
    
    OUT_FILE = OUTPUT_DIR + OUTPUT_FILE_NAME;
%     terms = ["dry", "pres", "moisture", "pump", "torque", "speed", "motor", "heating", "broke", "cur", "steam", "water", "vaccum"];

    IN_FILE = INPUT_DIR + INPUT_FILE_NAME;
    disp("Processing IN FILE " + IN_FILE);
    drawnow;

    termObj = config.generate_factors.terms;
    for i = 1:length(termObj)
        disp("Term name " + termObj(i).name); drawnow;
        for j = 1:length(termObj(i).key_match)
            disp("Keys " + termObj(i).key_match(j))
        end
    end

    % reading a process data file to get the header names.
    csv_fd = fopen(IN_FILE);
    header = fgetl(csv_fd);
    fclose(csv_fd);

    col_names = string(strsplit(header,','));
    col_details = [];
    for i = 1:length(col_names)
        col_details = [col_details; struct('name', col_names(i), 'index', i, 'is_used', 0)];
    end %end of for loop

    selected = [];
    totalColumn = 0;
    for t = 1:length(termObj)
        for i = 1:length(termObj(t).key_match)
            obj = [];
            k = 0;
            for j = 1:length(col_details)
                if ~any(strcmp(termObj(t).ignore, col_details(j).name)) && col_details(j).is_used == 0 && contains(col_details(j).name, termObj(t).key_match(i), 'IgnoreCase', true)
                    keyObj = struct('column_name', col_details(j).name, 'column_index', col_details(j).index);
                    col_details(j).is_used = 1;
                    obj = [obj; keyObj];
                    k = k + 1;
                end % end of if
            end % end of for
            totalColumn = totalColumn + k;
            selected = [selected, struct('keyword', termObj(t).name, 'fields', obj, 'fieldCount', k, 'ratio', (k*100)/length(col_names))];
        end
    end
    
    factors = struct(...
                     "total_column", length(col_names),... 
                     "used_column", totalColumn,...
                     "column_used_ratio", (totalColumn*100)/length(col_names),...
                     "selected", selected,...
                     "columns", col_details...
                    );
    save(OUT_FILE, 'factors');
    disp("Total Column will be used " + totalColumn);
    disp("Output file " + OUT_FILE + " saved successfully.");
    drawnow;
end