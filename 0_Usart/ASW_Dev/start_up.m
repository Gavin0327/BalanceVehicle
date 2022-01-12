function start_up
clc
clear all;
this_file_s = which(mfilename);
base_path_s = fileparts(this_file_s);    
p = {...
    [base_path_s '\model'],...
    [base_path_s '\lib'],...
    [base_path_s '\mscript'],...
};
for i = 1:length(p)
    addpath(genpath(p{i}));
end
evalin('base','lib_consts');
sl_refresh_customizations;

end