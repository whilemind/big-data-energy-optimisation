clear all;
clc;
%to generate metadata about row
main_p();

function [indexAcc, enlist] = get_eng_link(index, dateTime, obj)
%     disp("get energy data analysis...");
    drawnow;

    QA_DATE_FORMAT = 'dd/mm/yyyy HH:MM';
    ENG_DATE_FORMAT = 'dd-mmm-yy HH:MM:SS';
    date_limit = datenum(dateTime, QA_DATE_FORMAT);

    en_ind = [];
    for i = index:length(obj)
        eng_date = datenum(obj(i).datetime, ENG_DATE_FORMAT);
%         disp(dateTime + " QA , ENG " + obj(i).datetime);
%         drawnow;
        if(eng_date < date_limit)
            en_ind = [en_ind; i];
        else
            break;
        end
        
    end
    enlist = en_ind;
    indexAcc = i;

end

function [indexAcc, prlist] = get_pd_link(index, dateTime, obj)
%     disp("get process data analysis...");
    drawnow;
    
    QA_DATE_FORMAT = 'dd/mm/yyyy HH:MM';
    PD_DATE_FORMAT = 'dd/mm/yyyy HH:MM';
    date_limit = datenum(dateTime, QA_DATE_FORMAT);

    ind = [];
    for i = index:length(obj)
%         disp(dateTime + " QA , PD " + obj(i).datetime);
%         drawnow;
        pd_date = datenum(obj(i).datetime, PD_DATE_FORMAT);
        
        if(pd_date < date_limit)
            ind = [ind; i];
        else
            break;
        end
        
    end
    prlist = ind;
    indexAcc = i;

end


function data_analysis()
    disp("Running data analysis...");
    drawnow;
    
    QA_FILE  = "../data/out/QA_DATA_2017-18.mat";
    PD_FILE  = "../data/out/new_PD_2017-18_Q1-4.mat";
    ENG_FILE = "../data/out/new_PD_EX_M1.mat";
    ANA_FILE = "../data/out/metadata_2017-18.mat";
    
    pd_data = load(PD_FILE);
    qa_data = load(QA_FILE);
    eng_data = load(ENG_FILE);
    
    metadata = [];
    pd_index = 1;
    eng_index = 1;
    for i = 2:length(qa_data.mat_obj)
        disp("Processing line " + i);
        drawnow;
        if(i == 1512)
            disp("hello");
        end
        [pd_index, pr_list] = get_pd_link(pd_index, qa_data.mat_obj(i).date, pd_data.processData);
        [eng_index, en_list] = get_eng_link(eng_index, qa_data.mat_obj(i).date, eng_data.processData_m1);
        
%         sen_stat = [sen_mean; sen_stdiv];
%         eng_stat = [eng_mean; eng_stdiv];
        meta_da = struct('reel_id', qa_data.mat_obj(i).reel_id,...
            'pr_data',pr_list,...
            'eng_m1_data',en_list);
        metadata = [metadata; meta_da];
    end

    save(ANA_FILE, 'metadata');
end


function main_p()
    data_analysis();
end
%