%{ 
    This is used to show the progress
    USAGES:     
    At the beginning of the loop print this line.
        fprintf("Progress lines %d of .......................", length(qa_data.mat_obj));
    
    And at the end of the loop print this line
        fprintf("\n");
%}
function display_progress(percent, verbose)
    if(verbose == 1)
        s = sprintf('%d', percent);
        fprintf(repmat('\b', 1, numel(s))); 
        fprintf(s);
        drawnow;
    end
end