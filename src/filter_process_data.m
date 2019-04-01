function [datetime, flt_data] = filter_process_data(data)
    flt_data = [];
    for i = 1:length(data)
%         disp(data(i)); 
        if(i > 1)
            tmp = str2double(data(i));
%             if(isnan(tmp))
%                 flt_data = [flt_data, 0.0];
%             else
%                 flt_data = [flt_data, tmp];
%             end
            flt_data = [flt_data, tmp];
        else
            datetime = data(i);
        end
    end
end