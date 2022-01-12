function Gen_Signals
current_path = pwd;
str_id = strfind(current_path,'\');
excel_name = [current_path(str_id(end)+1:str_id(end)+3),'_signals.xlsx'];
model_name = current_path(str_id(end)+1:str_id(end)+3);
%% --------------------------------Creare Measures--------------------------%
reg_str = [model_name,'d_.*'];
[~,~,Meas] = xlsread(excel_name,'Measures');
len_size = size(Meas);
len = len_size(1);
n = 1;
ii = 1;
for i = 1:len
    c1_name = Meas{i,1};
    sub_id = strfind(c1_name,'__');
    if ~isempty(sub_id)
        sub_data{ii,1} = c1_name;
        sub_data{ii,2} = n-1; %the No2 is the first signals num
        ii = ii + 1;
    else
        sub_id = strfind(c1_name,'_');
        if length(sub_id)==1
            sub_data{ii,1} = c1_name;
            sub_data{ii,2} = n-1; %the No2 is the first signals num
            ii = ii + 1;
        end
    end
    sig_name = regexp(c1_name, reg_str,'match');
    if ~isempty(sig_name)
        meas_data{n,1} = sig_name; %singal name
        meas_data{n,2} = Meas{i,2};%siganl Unit
        meas_data{n,3} = Meas{i,3};%signal Min
        meas_data{n,4} = Meas{i,4};%signal Max
        meas_data{n,5} = Meas{i,5};%signal Data Type
        meas_data{n,6} = Meas{i,6};%signal Dec
        n = n + 1;
    else
        meas_data{n,1} = sig_name; %singal name
        meas_data{n,2} = '';%siganl Unit
        meas_data{n,3} = '';%signal Min
        meas_data{n,4} = '';%signal Max
        meas_data{n,5} = '';%signal Data Type
        meas_data{n,6} = '';%signal Dec
    end
end
% %------------------------------Measure M File-----------------------------%
% Get the CPU hostname
[ret, name] = system('hostname');
if ret ~= 0,
    if ispc
        name = getenv('COMPUTERNAME');
    else
        name = getenv('HOSTNAME');
    end
end
%Create Title info
authors = strtrim(lower(name));
outfile = [model_name,'_var.m'];
fileID = 0;
fileID = fopen(outfile,'w+');
title = [model_name,'_var.m ',date, ' By:',authors];
fprintf(fileID,['%%',title,'\n']);
fprintf(fileID,'disp(''%s'');\n',title);
fprintf(fileID,'%%-------------------------------------------------------------------------------\n');
fprintf(fileID,'%%Measures definitions for this feature;\n');
fprintf(fileID,'%%Use: a2l_var(name, units, min, max, data-type, description)\n');
fprintf(fileID,'%%-------------------------------------------------------------------------------\n');
fprintf(fileID,'\n');
%Subsystem length verify
len_sub_size = size(sub_data);
len_sub = len_sub_size(1);
len_meas = size(meas_data);
if len_sub == 1
    fprintf(fileID,['%%%% ',sub_data{1,1},'\n']);
    for i = 1:len_meas(1)
        if ~isempty(meas_data{i,1}) %Justment if have not the measures
        str_info = ['a2l_disp(''',meas_data{i,1}{1,1},'''',', ','''',meas_data{i,2},'''',', ',num2str(meas_data{i,3}),' ,  ',num2str(meas_data{i,4}),'  ,','''',meas_data{i,5},'''',',  ','''',meas_data{i,6},'''',');'];
        fprintf(fileID,'%s\n',str_info);
        end
    end
end
if len_sub == 2
    fprintf(fileID,['%%%% ',sub_data{1,1},'\n']);
    for i = 1:sub_data{2,2}
        str_info = ['a2l_disp(''',meas_data{i,1}{1,1},'''',', ','''',meas_data{i,2},'''',', ',num2str(meas_data{i,3}),' ,  ',num2str(meas_data{i,4}),'  ,','''',meas_data{i,5},'''',',  ','''',meas_data{i,6},'''',');'];
        fprintf(fileID,'%s\n',str_info);
    end
    fprintf(fileID,['%%%% ',sub_data{2,1},'\n']);
    for i = sub_data{2,2}+1:len_meas(1)
        str_info = ['a2l_disp(''',meas_data{i,1}{1,1},'''',', ','''',meas_data{i,2},'''',', ',num2str(meas_data{i,3}),' ,  ',num2str(meas_data{i,4}),'  ,','''',meas_data{i,5},'''',',  ','''',meas_data{i,6},'''',');'];
        fprintf(fileID,'%s\n',str_info);
    end
end
fclose(fileID);
disp(['Generator ' ,outfile, ' Finished !']);
%% --------------------------------Creare Paramters-------------------------%
[~,~,Cals] = xlsread(excel_name,'Parameters');
nanstr = num2str(Cals{1,1});
outfile_c = [model_name,'_cal.m'];
if ~strcmp(nanstr,'NaN')
    reg_str_c = [model_name,'([acm]+)_.*'];
    len_size_c = size(Cals);
    len_c = len_size_c(1);
    n = 1;
    ii = 1;
    for i = 1:len_c
        c1_name_c = Cals{i,1};
        sub_id_c = strfind(c1_name_c,'__');
        if ~isempty(sub_id_c)
            sub_data_c{ii,1} = c1_name_c;
            sub_data_c{ii,2} = n-1; %the No2 is the first signals num
            ii = ii + 1;
        else
            sub_id_c = strfind(c1_name_c,'_');
            if length(sub_id_c)==1
                sub_data_c{ii,1} = c1_name_c;
                sub_data_c{ii,2} = n-1; %the No2 is the first signals num
                ii = ii + 1;
            end
        end
        sig_name_c = regexp(c1_name_c, reg_str_c,'match');
        if ~isempty(sig_name_c)
            cals_data{n,1} = sig_name_c{1,1}; %singal name
            cals_data{n,2} = Cals{i,2};%siganl Value
            cals_data{n,3} = Cals{i,3};%siganl Unit
            cals_data{n,4} = Cals{i,4};%signal Min
            cals_data{n,5} = Cals{i,5};%signal Max
            cals_data{n,6} = Cals{i,6};%signal Data Type
            cals_data{n,7} = Cals{i,7};%signal Dec
            n = n + 1;
        end
    end
    %Create Title info
    ID_C = fopen(outfile_c,'w+');
    title_c = [model_name,'_cal.m ',date, ' By:',authors];
    fprintf(ID_C,['%%',title_c,'\n']);
    fprintf(ID_C,'disp(''%s'');\n',title_c);
    fprintf(ID_C,'%%-------------------------------------------------------------------------------\n');
    fprintf(ID_C,'%%Calibrations definitions for this feature;\n');
    fprintf(ID_C,'%%Use: a2l_cal(name, value, units, min, max, data-type, description)\n');
    fprintf(ID_C,'%%-------------------------------------------------------------------------------\n');
    fprintf(ID_C,'\n');
    %Subsystem length verify
    len_sub_size_c = size(sub_data_c);
    len_sub_c = len_sub_size_c(1);
    len_cals = size(cals_data);
    if len_sub_c == 1
        fprintf(ID_C,['%%%% ',sub_data_c{1,1},'\n']);
        for i = 1:len_cals(1)
            if ischar(cals_data{i,2})
                value_c =  ['[',strtrim(cals_data{i,2}),']'];
            else
                value_c = num2str(cals_data{i,2});
            end
            str_info_c = ['a2l_cal(''',cals_data{i,1},'''',', ',value_c,' ,','''',cals_data{i,3},'''',', ',num2str(cals_data{i,4}),' ,  ',num2str(cals_data{i,5}),'  ,','''',cals_data{i,6},'''',',  ','''',cals_data{i,7},'''',');'];
            fprintf(ID_C,'%s\n',str_info_c);
        end
    end
    if len_sub_c == 2
        fprintf(ID_C,['%%%% ',sub_data_c{1,1},'\n']);
        for i = 1:sub_data_c{2,2}
            if ischar(cals_data{i,2})
                value_c =  ['[',strtrim(cals_data{i,2}),']'];
            else
                value_c = num2str(cals_data{i,2});
            end
            str_info_c = ['a2l_cal(''',cals_data{i,1},'''',', ',value_c,' ,','''',cals_data{i,3},'''',', ',num2str(cals_data{i,4}),' ,  ',num2str(cals_data{i,5}),'  ,','''',cals_data{i,6},'''',',  ','''',cals_data{i,7},'''',');'];
            fprintf(ID_C,'%s\n',str_info_c);
        end
        fprintf(ID_C,['%%%% ',sub_data_c{2,1},'\n']);
        for i = sub_data_c{2,2}+1:len_cals(1)
            if ischar(cals_data{i,2})
                value_c =  ['[',strtrim(cals_data{i,2}),']'];
            else
                value_c = num2str(cals_data{i,2});
            end
            str_info_c = ['a2l_cal(''',cals_data{i,1},'''',', ',value_c,' ,','''',cals_data{i,3},'''',', ',num2str(cals_data{i,4}),' ,  ',num2str(cals_data{i,5}),'  ,','''',cals_data{i,6},'''',',  ','''',cals_data{i,7},'''',');'];
            fprintf(ID_C,'%s\n',str_info_c);
        end
    end
    fclose(ID_C);
    disp(['Generator ' ,outfile_c, ' Finished !']);
else
    disp([outfile_c,' Dont have Cals!']);
end
%% Create Config File
% TBD
end



