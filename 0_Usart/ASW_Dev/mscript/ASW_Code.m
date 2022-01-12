function ASW_Code
this_file_s = which(mfilename);
base_path_s = fileparts(this_file_s);  
str_id = strfind(base_path_s,'\');
mode_path = base_path_s(1,1:str_id(end)-1);
top_path = base_path_s(1,1:str_id(end-1)-1);
model_sw_path=fullfile(mode_path,['model'],[bdroot,'_ert_rtw']);
%Get C Source
c_filestruct = dir(fullfile(model_sw_path,'*.c'));   % 提取路径  
c_flies_names = {c_filestruct.name}';   % 获得符合条件文件名
disp('------------------------Copy C Sources Complised!-----------------------')
disp(c_flies_names);
%Get Header file
h_filestruct = dir(fullfile(model_sw_path,'*.h'));   % 提取路径  
h_flies_names = {h_filestruct.name}';   % 获得符合条件文件名
disp('------------------------Copy H Hearders Complised!-----------------------')
disp(h_flies_names);
file_names = cat(1,c_flies_names,h_flies_names);
cd(top_path);
filestruct = dir([top_path,'\ASW_Code']);
if isempty(filestruct)
    dist_path = fullfile(top_path,'ASW_Code');
    mkdir ASW_Code;
    for i = 1:length(file_names)
        if ~strcmp(file_names{i,1},'ert_main.c')
            filename = [model_sw_path,'\',file_names{i,1}];
            copyfile(filename,dist_path);
        end
    end
else
    rmdir('ASW_Code', 's');
    dist_path = fullfile(top_path,'ASW_Code');
    mkdir ASW_Code;
    for i = 1:length(file_names)
        if ~strcmp(file_names{i,1},'ert_main.c')
            filename = [model_sw_path,'\',file_names{i,1}];
            copyfile(filename,dist_path);
        end
    end
end
cd(base_path_s);
delete *.asv;
cd('F:\5_STM32\7_Clion\0_Usart\ASW_Dev\model');
end