clear all;
clc;

% Main function to call.
main_p();


function run_preprocess()
    % all the preprocessing method defined here so that we can
    % easily turn it on or off according to our need.
    methods = [
                struct('name', "process_csv_pd", 'func', @process_csv_pd, 'run', 0, 'desc', "This is function is to generate csv process data to mat file"),...
                struct('name', "process_m1_data", 'func', @process_m1_data, 'run', 0, 'desc', "This is function is to generate m1 energy data to mat file"),...  
                struct('name', "process_qa_data", 'func', @process_qa_data, 'run', 0, 'desc', "This is function is to generate csv QA data to mat file"),...  
                struct('name', "generate_factors", 'func', @generate_factors, 'run', 0, 'desc', "This is function is to generate factor fields data to mat file"),...
                struct('name', "generate_gradecode", 'func', @generate_gradecode, 'run', 1, 'desc', "This is function is to find out unique grade code"),...  
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


function run_analysis()
    % all the analysis method defined here so that we can
    % easily turn it on or off according to our need.
    methods = [
                struct('name', "data_analysis", 'func', @data_analysis, 'run', 1, 'desc', "This is function is to analysis data and save to mat file")...
              ];
          
    % calling all those analysis methods which <run> are enabled.      
    for method = methods
        if(method.run == 1)
            disp(">>>Running analysis method named " + method.name);
            drawnow;
            method.func();
            disp("<<<End of calling analysis method named " + method.name);
        end
    end

end


function run_postprocess()
    % all the postprocessing method defined here so that we can
    % easily turn it on or off according to our need.
    methods = [
                struct('name', "collect_bad_reel", 'func', @collect_bad_reel, 'run', 0, 'desc', "This is function is to generate all the bad reel data to mat file"),...
                struct('name', "collect_good_reel", 'func', @collect_good_reel, 'run', 0, 'desc', "This is function is to generate all the good reel data to mat file")...
              ];
          
    % calling all those postprocessing methods which <run> are enabled.      
    for method = methods
        if(method.run == 1)
            disp(">>>Running postprocess method named " + method.name);
            drawnow;
            method.func();
            disp("<<<End of calling postprocess method named " + method.name);
        end
    end

end


function main_p()
    % running all the preprocessing of input files.     
    run_preprocess();

    % generating the analytical mat files.    
    run_analysis();
    
    % running all the active prostprocess
    run_postprocess();
end
