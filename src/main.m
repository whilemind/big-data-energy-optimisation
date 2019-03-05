clear all;
clc;

global g_VERBOSE BATCH_SIZE;
g_VERBOSE = 1;
BATCH_SIZE = 3000;

main_p();


function [indexAcc, eng_data, data_mean, stdiv] = get_eng_analysis(index, dateTime, obj)
%     disp("get energy data analysis...");
    drawnow;

    QA_DATE_FORMAT = 'dd/mm/yyyy HH:MM';
    ENG_DATE_FORMAT = 'dd-mmm-yy HH:MM:SS';
    date_limit = datenum(dateTime, QA_DATE_FORMAT);

    eng_data = [];
    for i = index:length(obj)
        eng_date = datenum(obj(i).datetime, ENG_DATE_FORMAT);
%         disp(dateTime + " QA , ENG " + obj(i).datetime);
%         drawnow;
        if(eng_date < date_limit)
            eng_data = [eng_data; obj(i).M1_energy];
        else
            break;
        end
    end
    
    indexAcc = i;
    if(~isempty(eng_data))
        data_mean = nanmean(eng_data, 1);
        
        sz = size(eng_data);
        if(sz(1) == 1)
            stdiv = zeros(1, sz(2));
        else
            stdiv = std(eng_data, 1);    
        end
        
    else
        data_mean = zeros(1, length(obj(indexAcc).M1_energy));
        stdiv = zeros(1, length(obj(indexAcc).M1_energy));
    end

end


function [indexAcc, objArr, data_mean, stdiv, filter_arr] = get_pd_analysis(index, dateTime, obj, factors)
    % disp("get process data analysis...");
    drawnow;
    
    QA_DATE_FORMAT = 'dd/mm/yyyy HH:MM';
    PD_DATE_FORMAT = 'dd/mm/yyyy HH:MM';
    date_limit = datenum(dateTime, QA_DATE_FORMAT);

    sen_data = [];
    objArr = [];
    for i = index:length(obj)
        pd_date = datenum(obj(i).datetime, PD_DATE_FORMAT);
        if(pd_date < date_limit)
            sen_data = [sen_data; obj(i).sensorData];
            objArr = [objArr; obj(i)];
        else
            break;
        end
    end
    
    indexAcc = i;
    
    filter_arr = [];
    m = length(factors.selected);
    for i=1:m
        flen = length(factors.selected(i).fields);
        name = factors.selected(i).keyword;
        filter_data = struct('keyword', name);
        if(~isempty(sen_data))
            tmp = [];
            for j=1:flen
                ind = factors.selected(i).fields(j).column_index;
                tmp = [tmp, sen_data(:,ind)];
            end
            [filter_data(:).data] = tmp;
            [filter_data(:).mean] = nanmean(tmp, 1);
            [filter_data(:).mean_sum] = nansum(filter_data.mean);
        end
        filter_arr = [filter_arr; filter_data];
    end

    if(~isempty(sen_data))
        data_mean = nanmean(sen_data, 1);
        sz = size(sen_data);
        if(sz(1) == 1)
            stdiv = zeros(1, sz(2));
        else
            stdiv = std(sen_data, 1);    
        end
    else
        data_mean = zeros(1, length(obj(indexAcc).sensorData));
        stdiv = zeros(1, length(obj(indexAcc).sensorData));
    end
end

function [qa_index_start, pd_index_start, output_file_suffix] = chunk_data_analysis(config, qa_index_start, pd_index_start, output_file_suffix, batch_size, pd_data, qa_data, eng_data, fac_data)
    global g_VERBOSE;

    
    ANA_FILE = "" + config.analysis_data.out_dir + "" + config.analysis_data.output_file_name;
    ANA_EXT  = ""  + config.analysis_data.extension;
    
    analysis = [];

    eng_index_start = 1;
    line_count = 0;
    MAX_LINE = batch_size;
    
    fprintf("Progress lines %d of .......................", length(qa_data.mat_obj));
    for i = qa_index_start:length(qa_data.mat_obj)
        display_progress(i, g_VERBOSE);
        
        [pd_index_end, sen_data, sen_mean, sen_stdiv, filter_arr] = get_pd_analysis(pd_index_start, qa_data.mat_obj(i).date, pd_data.processData, fac_data.factors);
        [eng_index_end, energy_data, eng_mean, eng_stdiv] = get_eng_analysis(eng_index_start, qa_data.mat_obj(i).date, eng_data.processData_m1);
        
        sen_stat = [sen_mean; sen_stdiv];
        eng_stat = [eng_mean; eng_stdiv];
        qaData = struct(...
                        'qa_datetime', qa_data.mat_obj(i).date,...
                        'property', qa_data.mat_obj(i).property,...
                        'grade_code', qa_data.mat_obj(i).grade_code,...
                        'product_name', qa_data.mat_obj(i).product_name,...
                        'grammage', qa_data.mat_obj(i).grammage...
                        );
        procDataStruct = struct(...
                        'reel_id', qa_data.mat_obj(i).reel_id,...
                        'start_datetime', pd_data.processData(pd_index_start).datetime,...    
                        'end_datetime', pd_data.processData(pd_index_end - 1).datetime,...    
                        'proc_data', sen_data,...
                        'proc_data_stat', sen_stat...
                        );    

        engDataStruct = struct(...
                        'reel_id', qa_data.mat_obj(i).reel_id,...
                        'eng_start_datetime', eng_data.processData_m1(eng_index_start).datetime,...
                        'eng_end_datetime', eng_data.processData_m1(eng_index_end - 1).datetime,...
                        'eng_data', energy_data,...
                        'eng_data_stat', eng_stat...
                        );    
        
        tmp_ana = struct('reel_id', qa_data.mat_obj(i).reel_id);
        for j=1:length(filter_arr)
            if(isfield(filter_arr, "mean_sum"))
                [tmp_ana(:).(filter_arr(j).keyword)] = filter_arr(j).mean_sum;    
            else
                [tmp_ana(:).(filter_arr(j).keyword)] = NaN;    
            end
        end

        
        
        [tmp_ana(:).filter] = filter_arr;
        
        [tmp_ana(:).qa_data] = qaData;
        [tmp_ana(:).process_data_details] = procDataStruct;
        [tmp_ana(:).energy_data_details] = engDataStruct;

        [tmp_ana(:).pd_start] = procDataStruct.start_datetime;
        [tmp_ana(:).pd_end] = procDataStruct.end_datetime;
        [tmp_ana(:).eng_start] = engDataStruct.eng_start_datetime;
        [tmp_ana(:).eng_end] = engDataStruct.eng_end_datetime;
        [tmp_ana(:).qa_date] = qaData.qa_datetime;
        
        analysis = [analysis; tmp_ana];
        
        clearvars qaData;
        clearvars procDataStruct;
        clearvars engDataStruct;
        clearvars temp_ana;
        
        pd_index_start = pd_index_end;
        eng_index_start = eng_index_end;
        
        line_count = line_count + 1;
        if(line_count == MAX_LINE)
            save(ANA_FILE + "_" + int2str(output_file_suffix) + ANA_EXT, 'analysis');
            analysis = [];
            break;
        end
    end
    
    % There might has some line left to save.
    if(~isempty(analysis)) 
        save(ANA_FILE + "_" + int2str(output_file_suffix) + ANA_EXT, 'analysis');
    end

    clearvars analysis;
    qa_index_start = i + 1;
    output_file_suffix = output_file_suffix + 1;
    fprintf("\n");
end


function data_analysis(config)
    global BATCH_SIZE;

    disp("Running data analysis...");
    drawnow;
    
    % Opening all the relavent mat file.
    QA_FILE  = "" + config.process_qa_data.out_dir + "" + config.process_qa_data.output_file_name;
    PD_FILE  = "" + config.process_csv_pd.out_dir + "" + config.process_csv_pd.output_file_name;
    ENG_FILE = "" + config.process_m1_data.out_dir + "" + config.process_m1_data.output_file_name;
    FAC_FILE = "" + config.generate_factors.out_dir + "" + config.generate_factors.output_file_name;

 
    disp("Loading process data file " + PD_FILE);
    drawnow;
    tic;
    pd_data = load(PD_FILE);
    toc;
    
    disp("Loading qa data file " + QA_FILE);
    drawnow;
    tic;
    qa_data = load(QA_FILE);
    toc;
    
    disp("Loading energy data file " + ENG_FILE);
    drawnow;
    tic;
    eng_data = load(ENG_FILE);
    toc;
    
    disp("Loading factors data file " + FAC_FILE);
    drawnow;
    tic;
    fac_data = load(FAC_FILE);
    toc;
    % end of opening mat file.
    
    
    pd_start_index = 1;
    qa_index = 1;
    file_suffix = 1;
    while qa_index < length(qa_data.mat_obj)
        tic;
        [qa_index, pd_start_index, file_suffix] = chunk_data_analysis(config, qa_index, pd_start_index, file_suffix, BATCH_SIZE, pd_data, qa_data, eng_data, fac_data);
        disp("QA index " + qa_index + " PD index " + pd_start_index + " suffix " + file_suffix);
        drawnow;
        toc;
    end
  
end


function run_preprocess()
    % all the preprocessing method defined here so that we can
    % easily turn it on or off according to our need.
    methods = [
                struct('name', "process_csv_pd", 'func', @process_csv_pd, 'run', 0, 'desc', "This is function is to generate csv process data to mat file"),...
                struct('name', "process_m1_data", 'func', @process_m1_data, 'run', 0, 'desc', "This is function is to generate m1 energy data to mat file"),...  
                struct('name', "process_qa_data", 'func', @process_qa_data, 'run', 0, 'desc', "This is function is to generate csv QA data to mat file"),...  
                struct('name', "generate_factors", 'func', @generate_factors, 'run', 0, 'desc', "This is function is to generate factor fields data to mat file"),...  
              ];
          
    % calling all those preprocessing methods which <run> are enabled.      
    for method = methods
        if(method.run == 1)
            disp(">>>Running preprocess method named " + method.name);
            drawnow;
            method.func();
            disp("<<<End of calling preprocess method named " + method.name);
        end
    end

end


function main_p()
    % Loading the configuration file     
    config = jsondecode(fileread("../config/config.json"));
    
    % running all the preprocessing of input files.     
    run_preprocess();

    % generating the analytical mat files.    
    data_analysis(config);
    
end
