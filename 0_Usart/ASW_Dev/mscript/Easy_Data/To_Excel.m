function To_Excel
%By:Du QingYa  @2020.09.30 Signals and Paramters from model to excel;
%Get the Resovle signals of the model
tt = 1;
Sub_Path = find_system(bdroot,'SearchDepth', 1,'BlockType','SubSystem');% find the model SubSystem path
%Throuth the funcion of get_line find the SubSystem name and the Resovle
%signals;
for t = 1:length(Sub_Path)
    Sub_Path_Name = Sub_Path{t,1};
    str = strfind(Sub_Path_Name,'_');
    if ~isempty(str)
        str_id = strfind(Sub_Path_Name,'/');
        Sub_Name{tt,1} = Sub_Path_Name(str_id(1)+1:end);
        Sig_Name{tt,1} = get_line(Sub_Path_Name);
        [Con_Name{tt,1},Relay_Name{tt,1},LkUp1_Name{tt,1},LkUp2_Name{tt,1},Interval_Name{tt,1}] = get_cals(Sub_Path_Name);
        tt = tt+1;
        %         get_param(paths);
    end
end
sig_data = cat(2,Sub_Name,Sig_Name);
cal_data = cat(2,Sub_Name,Con_Name,Relay_Name,LkUp1_Name,LkUp2_Name,Interval_Name);
%Get the Parameters from model

% assignin('base','sig_data',sig_data);
Create_Excel(sig_data,cal_data);
end
% get_line:
%1)use find_system fun find the all line of model;2)Then Use the cmd of
%MustResolveToSignalObject verify if the signals is resovle or not;3)if
%resovle ,should get the name of line;4)regexp to find the signals of
%current model;
function [meas_names] = get_line(paths)
n = 1;
model_meas_buff = {};
all_line =  find_system(paths,'FindAll','on','Type','Line');
for i = 1:length(all_line)
    if get(all_line(i,1), 'MustResolveToSignalObject')
        names_buff = get_param(all_line(i,1),'name');
        cpm_str = [bdroot 'd_.*'];
        key_valid = regexp(names_buff, cpm_str,'match');
        if ~isempty(key_valid)
            model_meas_buff{n,1} = names_buff;
            n = n+1;
        end
    end
end
meas_names = unique(model_meas_buff);
end
%Get Parameter
function [con_names,relay_names,dim1_names,dim2_names,intervals_names] = get_cals(paths)
ii = 1;
cons_names = {};
relay_names = {};
intervals_names = {};
dim1_names = {};
dim2_names = {};
all_con =  find_system(paths,'FindAll','on','BlockType','Constant');
if ~isempty(all_con)
    for i = 1:length(all_con)
        if isempty(str2num(get_param(all_con(i,1),'Value')))
            cons_names{ii,1} = get_param(all_con(i,1),'Value');
            ii = ii+1;
        end
    end
    if ~isempty(cons_names);
        con_names = unique(cons_names);
    else
        con_names = {};
    end
else
    con_names = {};
end

ii = 1;
all_relay =  find_system(paths,'FindAll','on','BlockType','Relay');
if ~isempty(all_relay)
    for i = 1:length(all_relay)
        relay_names{ii,1} = get_param(all_relay(i,1),'OnSwitchValue');
        relay_names{ii,2} = get_param(all_relay(i,1),'OffSwitchValue');
        ii = ii + 1;
    end
else
    relay_names = {};
end

ii = 1;
Intervals =  find_system(paths,'FindAll','on','MaskType','Interval Test');
if ~isempty(Intervals)
    for i = 1:length(Intervals)
        intervals_names{ii,1} = get_param(Intervals(i,1),'uplimit');
        intervals_names{ii,2} = get_param(Intervals(i,1),'lowlimit');
        ii = ii + 1;
    end
else
    intervals_names = {};
end

ii = 1;
iii = 1;
all_lookUp =  find_system(paths,'FindAll','on','BlockType','Lookup_n-D');
dim1_names = {};
dim2_names = {};
if ~isempty(all_lookUp)
    for i = 1:length(all_lookUp)
        dim = get_param(all_lookUp(i,1),'NumberOfTableDimensions');
        if dim == '1'
            dim1_names{ii,1} = get_param(all_lookUp(i,1),'BreakpointsForDimension1');
            dim1_names{ii,2} = get_param(all_lookUp(i,1),'Table');
            ii = ii + 1;
        end
        if dim == '2'
            dim2_names{iii,1} = get_param(all_lookUp(i,1),'BreakpointsForDimension1');
            dim2_names{iii,2} = get_param(all_lookUp(i,1),'BreakpointsForDimension2');
            dim2_names{iii,3} = get_param(all_lookUp(i,1),'Table');
            iii = iii + 1;
        end
    end
end
end
function Create_Excel(sig_data,cal_data)
% sig_data = evalin('base','sig_data');
len_data = size(sig_data);
len = len_data(1);
%Key Word of Signals
%u-电压；i-电流；b-布尔值；t-温度；tq-扭矩；pwr-功率；p-PWM；q-电量或SOC；
%n-转速；kph-车速；pt-开度；kp-kpa气压；km-里程；kwph-效率;flg-使能条件
key_str = { %关键字，默认值，单位，最小值，最大值，信号类型，描述
    'V',0,'V' ,0,100,'single',' Voltage';
    'flg',0,'flg',0,1,'boolean','State';
    'C',0,'C',-50,100,'single','Temperature';
    'kWh',0,'kWh',-50,100,'single',' ';
    'Nm',0,'Nm',0,300,'single',' ';
    'Kw',0,'Kw',0,100,'single',' ';
    'kPa',0,'kPa',0,100,'single',' ';
    'rpm',0,'rpm',0,10000,'single',' ';
    '%',0,'pct',0,100,'single',' ';
    'Km/h',0,'kph',0,200,'single',' Speed';
    'Km',0,'km',0,60000,'single','Mileage';
    'Kw/Km',0,'kWhpkm',0,300,'single',' ';
    'kWh/Km',0,'kWhphundkm',0,300,'single: ',' ';
    'enum',0,'enum',0,255,'uint8 ','The States';
    'fat',0,'Factor',0,255,'single ',' ';
    'A',0,'A',0,255,'single ',' ';
    's',0,'s',0,255,'single ',' ';
    'flg ',0,'ovrdval',0,1,'boolean ',' ';
    'flg',0,'ovrdflg',0,1,'boolean',' ';
    };
%Get Signals
n = 1;
cn = 1;
nn =1;
cnn = 1;
nnn = 1;
j = 1;
if len==1
    % Just have one Subsystem
    % -------------------------------Measures-----------------------------%
    Sub_Name{1,1} = sig_data{1,1};
    Rag_Sub_Name{1,1} = ['A1:F1'];
    Rag_Format{1,1} = ['A2:F2'];
    Sig_Names = {};
    for ii = 1:length(sig_data{1,2})
        Sig_Names{1,1}{n,1} = sig_data{1,2}{ii,1};
        str_id = findstr(sig_data{1,2}{ii,1},'_');
        str_unit = Sig_Names{1,1}{n,1}(str_id(end)+1:end);
        str_dec = Sig_Names{1,1}{n,1}(str_id(2)+1:str_id(end)-1);
        Ids = strcmpi(str_unit,key_str(:,3));
        verify_Id = find(Ids);
        if ~isempty(verify_Id)
            Unit_Names{1,1}{n,1} = key_str{verify_Id,1};
            Min_Names{1,1}{n,1} = num2str(key_str{verify_Id,4});
            Max_Names{1,1}{n,1} = num2str(key_str{verify_Id,5});
            Type_Names{1,1}{n,1} = key_str{verify_Id,6};
            Dec_Names{1,1}{n,1} = str_dec;
        else
            Unit_Names{1,1}{n,1} = 'tbd';
            Min_Names{1,1}{n,1} = 'tbd';
            Max_Names{1,1}{n,1} = 'tbd';
            Type_Names{1,1}{n,1} = 'tbd';
            Dec_Names{1,1}{n,1} = 'tbd';
        end
        n = n + 1;
    end
    if ~isempty(Sig_Names)
        All_Sig_Name{1,1} = cat(2,Sig_Names{1,1},Unit_Names{1,1},Min_Names{1,1},Max_Names{1,1},Type_Names{1,1},Dec_Names{1,1});
        Rag_Sig_Name{1,1} = ['A3:F' num2str(n+1)];
    end
    % -------------------------------Calibration--------------------------%
    % Identify parameters type:constant/relay/interval/Lookup1/lookup2
    Rag_Sub_Name_Cal = {};
    if ~isempty(cal_data{1,2})||~isempty(cal_data{1,3})||~isempty(cal_data{1,4})||~isempty(cal_data{1,5})||~isempty(cal_data{1,6})
        Sub_Name_Cal{1,1} = cal_data{1,1};
        Rag_Sub_Name_Cal{1,1} = ['A1:G1'];
        Rag_Format_Cal{1,1} = ['A2:G2'];
        %Constants
        if ~isempty(cal_data{1,2})
            for ii = 1:length(cal_data{1,2})
                Cal_Names{1,1}{cn,1} = cal_data{1,2}{ii,1};
                str_id = findstr(cal_data{1,2}{ii,1},'_');
                str_unit = Cal_Names{1,1}{cn,1}(str_id(end)+1:end);
                str_dec = Cal_Names{1,1}{cn,1}(str_id(2)+1:str_id(end)-1);
                Ids = strcmpi(str_unit,key_str(:,3));
                verify_Id = find(Ids);
                if ~isempty(verify_Id)
                    Unit_Names_Cal{1,1}{cn,1} = key_str{verify_Id,1};
                    Value_Names_Cal{1,1}{cn,1} = ' ';
                    Min_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,4});
                    Max_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,5});
                    Type_Names_Cal{1,1}{cn,1} = key_str{verify_Id,6};
                    Dec_Names_Cal{1,1}{cn,1} = str_dec;
                else
                    Unit_Names_Cal{1,1}{cn,1} = ' ';
                    Value_Names_Cal{1,1}{cn,1} = ' ';
                    Min_Names_Cal{1,1}{cn,1} = ' ';
                    Max_Names_Cal{1,1}{cn,1} = ' ';
                    Type_Names_Cal{1,1}{cn,1} = ' ';
                    Dec_Names_Cal{1,1}{cn,1} = ' ';
                end
                cn = cn + 1;
            end
        end
        %Relay
        if ~isempty(cal_data{1,3})
            len_relays = size(cal_data{1,3});
            len_relay = len_relays(1,1);
            for ii = 1:len_relay
                %Switch On
                Cal_Names{1,1}{cn,1} = cal_data{1,3}{ii,1};
                str_id = findstr(cal_data{1,3}{ii,1},'_');
                str_unit = Cal_Names{1,1}{cn,1}(str_id(end)+1:end);
                str_dec = Cal_Names{1,1}{cn,1}(str_id(2)+1:str_id(end)-1);
                Ids = strcmpi(str_unit,key_str(:,3));
                verify_Id = find(Ids);
                if ~isempty(verify_Id)
                    Unit_Names_Cal{1,1}{cn,1} = key_str{verify_Id,1};
                    Value_Names_Cal{1,1}{cn,1} = ' ';
                    Min_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,4});
                    Max_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,5});
                    Type_Names_Cal{1,1}{cn,1} = key_str{verify_Id,6};
                    Dec_Names_Cal{1,1}{cn,1} = str_dec;
                else
                    Unit_Names_Cal{1,1}{cn,1} = ' ';
                    Value_Names_Cal{1,1}{cn,1} = ' ';
                    Min_Names_Cal{1,1}{cn,1} = ' ';
                    Max_Names_Cal{1,1}{cn,1} = ' ';
                    Type_Names_Cal{1,1}{cn,1} = ' ';
                    Dec_Names_Cal{1,1}{cn,1} = ' ';
                end
                cn = cn + 1;
                %Swtich Off
                Cal_Names{1,1}{cn,1} = cal_data{1,3}{ii,2};
                str_id = findstr(cal_data{1,3}{ii,2},'_');
                str_unit = Cal_Names{1,1}{cn,1}(str_id(end)+1:end);
                str_dec = Cal_Names{1,1}{cn,1}(str_id(2)+1:str_id(end)-1);
                Ids = strcmpi(str_unit,key_str(:,3));
                verify_Id = find(Ids);
                if ~isempty(verify_Id)
                    Unit_Names_Cal{1,1}{cn,1} = key_str{verify_Id,1};
                    Value_Names_Cal{1,1}{cn,1} = ' ';
                    Min_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,4});
                    Max_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,5});
                    Type_Names_Cal{1,1}{cn,1} = key_str{verify_Id,6};
                    Dec_Names_Cal{1,1}{cn,1} = str_dec;
                else
                    Unit_Names_Cal{1,1}{cn,1} = ' ';
                    Value_Names_Cal{1,1}{cn,1} = ' ';
                    Min_Names_Cal{1,1}{cn,1} = ' ';
                    Max_Names_Cal{1,1}{cn,1} = ' ';
                    Type_Names_Cal{1,1}{cn,1} = ' ';
                    Dec_Names_Cal{1,1}{cn,1} = ' ';
                end
                cn = cn + 1;
            end
        end
        %Look_Up 1D
        if ~isempty(cal_data{1,4})
            len_1ds = size(cal_data{1,4});
            len_1d = len_1ds(1,1);
            for ii = 1:len_1d
                %Input1 of 1_Dim MAP
                Cal_Names{1,1}{cn,1} = cal_data{1,4}{ii,1};
                str_id = findstr(cal_data{1,4}{ii,1},'_');
                str_unit = Cal_Names{1,1}{cn,1}(str_id(end)+1:end);
                str_dec = Cal_Names{1,1}{cn,1}(str_id(2)+1:str_id(end)-1);
                Ids = strcmpi(str_unit,key_str(:,3));
                verify_Id = find(Ids);
                if ~isempty(verify_Id)
                    Unit_Names_Cal{1,1}{cn,1} = key_str{verify_Id,1};
                    Value_Names_Cal{1,1}{cn,1} = ' ';
                    Min_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,4});
                    Max_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,5});
                    Type_Names_Cal{1,1}{cn,1} = key_str{verify_Id,6};
                    Dec_Names_Cal{1,1}{cn,1} = str_dec;
                else
                    Unit_Names_Cal{1,1}{cn,1} = ' ';
                    Value_Names_Cal{1,1}{cn,1} = ' ';
                    Min_Names_Cal{1,1}{cn,1} = ' ';
                    Max_Names_Cal{1,1}{cn,1} = ' ';
                    Type_Names_Cal{1,1}{cn,1} = ' ';
                    Dec_Names_Cal{1,1}{cn,1} = ' ';
                end
                cn = cn + 1;
                %Output of 1_Dim MAP
                Cal_Names{1,1}{cn,1} = cal_data{1,4}{ii,2};
                str_id = findstr(cal_data{1,4}{ii,2},'_');
                str_unit = Cal_Names{1,1}{cn,1}(str_id(end)+1:end);
                str_dec = Cal_Names{1,1}{cn,1}(str_id(2)+1:str_id(end)-1);
                Ids = strcmpi(str_unit,key_str(:,3));
                verify_Id = find(Ids);
                if ~isempty(verify_Id)
                    Unit_Names_Cal{1,1}{cn,1} = key_str{verify_Id,1};
                    Value_Names_Cal{1,1}{cn,1} = ' ';
                    Min_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,4});
                    Max_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,5});
                    Type_Names_Cal{1,1}{cn,1} = key_str{verify_Id,6};
                    Dec_Names_Cal{1,1}{cn,1} = str_dec;
                else
                    Unit_Names_Cal{1,1}{cn,1} = ' ';
                    Value_Names_Cal{1,1}{cn,1} = ' ';
                    Min_Names_Cal{1,1}{cn,1} = ' ';
                    Max_Names_Cal{1,1}{cn,1} = ' ';
                    Type_Names_Cal{1,1}{cn,1} = ' ';
                    Dec_Names_Cal{1,1}{cn,1} = ' ';
                end
                cn = cn + 1;
            end
        end
        %Look_Up 2D
        if ~isempty(cal_data{1,5})
            len_2ds = size(cal_data{1,5});
            len_2d = len_2ds(1,1);
            for ii = 1:len_2d
                %Input1 of 2_Dim MAP
                Cal_Names{1,1}{cn,1} = cal_data{1,5}{ii,1};
                str_id = findstr(cal_data{1,5}{ii,1},'_');
                str_unit = Cal_Names{1,1}{cn,1}(str_id(end)+1:end);
                str_dec = Cal_Names{1,1}{cn,1}(str_id(2)+1:str_id(end)-1);
                Ids = strcmpi(str_unit,key_str(:,3));
                verify_Id = find(Ids);
                if ~isempty(verify_Id)
                    Unit_Names_Cal{1,1}{cn,1} = key_str{verify_Id,1};
                    Value_Names_Cal{1,1}{cn,1} = ' ';
                    Min_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,4});
                    Max_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,5});
                    Type_Names_Cal{1,1}{cn,1} = key_str{verify_Id,6};
                    Dec_Names_Cal{1,1}{cn,1} = str_dec;
                else
                    Unit_Names_Cal{1,1}{cn,1} = ' ';
                    Value_Names_Cal{1,1}{cn,1} = ' ';
                    Min_Names_Cal{1,1}{cn,1} = ' ';
                    Max_Names_Cal{1,1}{cn,1} = ' ';
                    Type_Names_Cal{1,1}{cn,1} = ' ';
                    Dec_Names_Cal{1,1}{cn,1} = ' ';
                end
                cn = cn + 1;
                %Input2 of 2_Dim MAP
                Cal_Names{1,1}{cn,1} = cal_data{1,5}{ii,2};
                str_id = findstr(cal_data{1,5}{ii,2},'_');
                str_unit = Cal_Names{1,1}{cn,1}(str_id(end)+1:end);
                str_dec = Cal_Names{1,1}{cn,1}(str_id(2)+1:str_id(end)-1);
                Ids = strcmpi(str_unit,key_str(:,3));
                verify_Id = find(Ids);
                if ~isempty(verify_Id)
                    Unit_Names_Cal{1,1}{cn,1} = key_str{verify_Id,1};
                    Value_Names_Cal{1,1}{cn,1} = ' ';
                    Min_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,4});
                    Max_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,5});
                    Type_Names_Cal{1,1}{cn,1} = key_str{verify_Id,6};
                    Dec_Names_Cal{1,1}{cn,1} = str_dec;
                else
                    Unit_Names_Cal{1,1}{cn,1} = ' ';
                    Value_Names_Cal{1,1}{cn,1} = ' ';
                    Min_Names_Cal{1,1}{cn,1} = ' ';
                    Max_Names_Cal{1,1}{cn,1} = ' ';
                    Type_Names_Cal{1,1}{cn,1} = ' ';
                    Dec_Names_Cal{1,1}{cn,1} = ' ';
                end
                cn = cn + 1;
                %Output of 2_Dim MAP
                Cal_Names{1,1}{cn,1} = cal_data{1,5}{ii,3};
                str_id = findstr(cal_data{1,5}{ii,3},'_');
                str_unit = Cal_Names{1,1}{cn,1}(str_id(end)+1:end);
                str_dec = Cal_Names{1,1}{cn,1}(str_id(2)+1:str_id(end)-1);
                Ids = strcmpi(str_unit,key_str(:,3));
                verify_Id = find(Ids);
                if ~isempty(verify_Id)
                    Unit_Names_Cal{1,1}{cn,1} = key_str{verify_Id,1};
                    Value_Names_Cal{1,1}{cn,1} = ' ';
                    Min_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,4});
                    Max_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,5});
                    Type_Names_Cal{1,1}{cn,1} = key_str{verify_Id,6};
                    Dec_Names_Cal{1,1}{cn,1} = str_dec;
                else
                    Unit_Names_Cal{1,1}{cn,1} = ' ';
                    Value_Names_Cal{1,1}{cn,1} = ' ';
                    Min_Names_Cal{1,1}{cn,1} = ' ';
                    Max_Names_Cal{1,1}{cn,1} = ' ';
                    Type_Names_Cal{1,1}{cn,1} = ' ';
                    Dec_Names_Cal{1,1}{cn,1} = ' ';
                end
                cn = cn + 1;
            end
        end
        %Interval
        if ~isempty(cal_data{1,6})
            len_intervals = size(cal_data{1,6});
            len_interval = len_intervals(1,1);
            for ii = 1:len_interval
                %Upper limit
                Cal_Names{1,1}{cn,1} = cal_data{1,6}{ii,1};
                str_id = findstr(cal_data{1,6}{ii,1},'_');
                str_unit = Cal_Names{1,1}{cn,1}(str_id(end)+1:end);
                str_dec = Cal_Names{1,1}{cn,1}(str_id(2)+1:str_id(end)-1);
                Ids = strcmpi(str_unit,key_str(:,3));
                verify_Id = find(Ids);
                if ~isempty(verify_Id)
                    Unit_Names_Cal{1,1}{cn,1} = key_str{verify_Id,1};
                    Value_Names_Cal{1,1}{cn,1} = ' ';
                    Min_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,4});
                    Max_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,5});
                    Type_Names_Cal{1,1}{cn,1} = key_str{verify_Id,6};
                    Dec_Names_Cal{1,1}{cn,1} = str_dec;
                else
                    Unit_Names_Cal{1,1}{cn,1} = ' ';
                    Value_Names_Cal{1,1}{cn,1} = ' ';
                    Min_Names_Cal{1,1}{cn,1} = ' ';
                    Max_Names_Cal{1,1}{cn,1} = ' ';
                    Type_Names_Cal{1,1}{cn,1} = ' ';
                    Dec_Names_Cal{1,1}{cn,1} = ' ';
                end
                cn = cn + 1;
                %Lower limit
                Cal_Names{1,1}{cn,1} = cal_data{1,6}{ii,2};
                str_id = findstr(cal_data{1,6}{ii,2},'_');
                str_unit = Cal_Names{1,1}{cn,1}(str_id(end)+1:end);
                str_dec = Cal_Names{1,1}{cn,1}(str_id(2)+1:str_id(end)-1);
                Ids = strcmpi(str_unit,key_str(:,3));
                verify_Id = find(Ids);
                if ~isempty(verify_Id)
                    Unit_Names_Cal{1,1}{cn,1} = key_str{verify_Id,1};
                    Value_Names_Cal{1,1}{cn,1} = ' ';
                    Min_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,4});
                    Max_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,5});
                    Type_Names_Cal{1,1}{cn,1} = key_str{verify_Id,6};
                    Dec_Names_Cal{1,1}{cn,1} = str_dec;
                else
                    Unit_Names_Cal{1,1}{cn,1} = ' ';
                    Value_Names_Cal{1,1}{cn,1} = ' ';
                    Min_Names_Cal{1,1}{cn,1} = ' ';
                    Max_Names_Cal{1,1}{cn,1} = ' ';
                    Type_Names_Cal{1,1}{cn,1} = ' ';
                    Dec_Names_Cal{1,1}{cn,1} = ' ';
                end
                cn = cn + 1;
            end
        end
        All_Cal_Name{1,1} = cat(2,Cal_Names{1,1},Value_Names_Cal{1,1},Unit_Names_Cal{1,1},Min_Names_Cal{1,1},Max_Names_Cal{1,1},Type_Names_Cal{1,1},Dec_Names_Cal{1,1});
        Rag_Cal_Name{1,1} = ['A3:G' num2str(cn+1)];
        %     else
        %         All_Cal_Name{1,1} = {'','','','','','',''};
        %         Rag_Cal_Name{1,1} = ['A3:G3'];
    end
    
else if len==2
        %------------------------------Measures---------------------------%
        Sub_Name{1,1} = sig_data{1,1};
        Rag_Sub_Name{1,1} = ['A1:F1'];
        Rag_Format{1,1} = ['A2:F2'];
        Sig_Names = {};
        for ii = 1:length(sig_data{1,2})
            Sig_Names{1,1}{n,1} = sig_data{1,2}{ii,1};
            str_id = findstr(sig_data{1,2}{ii,1},'_');
            str_unit = Sig_Names{1,1}{n,1}((str_id(end)+1):end);
            str_dec = Sig_Names{1,1}{n,1}((str_id(2)+1):(str_id(end)-1));
            Ids = strcmpi(str_unit,key_str(:,3));
            verify_Id = find(Ids);
            if ~isempty(verify_Id)
                Unit_Names{1,1}{n,1} = key_str{verify_Id,1};
                Min_Names{1,1}{n,1} = num2str(key_str{verify_Id,4});
                Max_Names{1,1}{n,1} = num2str(key_str{verify_Id,5});
                Type_Names{1,1}{n,1} = key_str{verify_Id,6};
                Dec_Names{1,1}{n,1} = str_dec;
            else
                Unit_Names{1,1}{n,1} = 'tbd';
                Min_Names{1,1}{n,1} = 'tbd';
                Max_Names{1,1}{n,1} = 'tbd';
                Type_Names{1,1}{n,1} = 'tbd';
                Dec_Names{1,1}{n,1} = 'tbd';
            end
            n = n + 1;
        end
        if ~isempty(Sig_Names)
            All_Sig_Name{1,1}= cat(2,Sig_Names{1,1},Unit_Names{1,1},Min_Names{1,1},Max_Names{1,1},Type_Names{1,1},Dec_Names{1,1});
            Rag_Sig_Name{1,1} = ['A3:F' num2str(n+1)];
        end
        % -------------------------------Calibration--------------------------%
        % Identify parameters type:constant/relay/Lookup1/lookup2
        if ~isempty(cal_data{1,2})||~isempty(cal_data{1,3})||~isempty(cal_data{1,4})||~isempty(cal_data{1,5})||~isempty(cal_data{1,6})
            Sub_Name_Cal{1,1} = cal_data{1,1};
            Rag_Sub_Name_Cal{1,1} = ['A1:G1'];
            Rag_Format_Cal{1,1} = ['A2:G2'];
            %Constants
            if ~isempty(cal_data{1,2})
                for ii = 1:length(cal_data{1,2})
                    Cal_Names{1,1}{cn,1} = cal_data{1,2}{ii,1};
                    str_id = findstr(cal_data{1,2}{ii,1},'_');
                    str_unit = Cal_Names{1,1}{cn,1}(str_id(end)+1:end);
                    str_dec = Cal_Names{1,1}{cn,1}(str_id(2)+1:str_id(end)-1);
                    Ids = strcmpi(str_unit,key_str(:,3));
                    verify_Id = find(Ids);
                    if ~isempty(verify_Id)
                        Unit_Names_Cal{1,1}{cn,1} = key_str{verify_Id,1};
                        Value_Names_Cal{1,1}{cn,1} = ' ';
                        Min_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,4});
                        Max_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,5});
                        Type_Names_Cal{1,1}{cn,1} = key_str{verify_Id,6};
                        Dec_Names_Cal{1,1}{cn,1} = str_dec;
                    else
                        Unit_Names_Cal{1,1}{cn,1} = ' ';
                        Value_Names_Cal{1,1}{cn,1} = ' ';
                        Min_Names_Cal{1,1}{cn,1} = ' ';
                        Max_Names_Cal{1,1}{cn,1} = ' ';
                        Type_Names_Cal{1,1}{cn,1} = ' ';
                        Dec_Names_Cal{1,1}{cn,1} = ' ';
                    end
                    cn = cn + 1;
                end
            end
            %Relays
            if ~isempty(cal_data{1,3})
                len_relays = size(cal_data{1,3});
                len_relay = len_relays(1,1);
                for ii = 1:len_relay
                    %Switch On
                    Cal_Names{1,1}{cn,1} = cal_data{1,3}{ii,1};
                    str_id = findstr(cal_data{1,3}{ii,1},'_');
                    str_unit = Cal_Names{1,1}{cn,1}(str_id(end)+1:end);
                    str_dec = Cal_Names{1,1}{cn,1}(str_id(2)+1:str_id(end)-1);
                    Ids = strcmpi(str_unit,key_str(:,3));
                    verify_Id = find(Ids);
                    if ~isempty(verify_Id)
                        Unit_Names_Cal{1,1}{cn,1} = key_str{verify_Id,1};
                        Value_Names_Cal{1,1}{cn,1} = ' ';
                        Min_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,4});
                        Max_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,5});
                        Type_Names_Cal{1,1}{cn,1} = key_str{verify_Id,6};
                        Dec_Names_Cal{1,1}{cn,1} = str_dec;
                    else
                        Unit_Names_Cal{1,1}{cn,1} = ' ';
                        Value_Names_Cal{1,1}{cn,1} = ' ';
                        Min_Names_Cal{1,1}{cn,1} = ' ';
                        Max_Names_Cal{1,1}{cn,1} = ' ';
                        Type_Names_Cal{1,1}{cn,1} = ' ';
                        Dec_Names_Cal{1,1}{cn,1} = ' ';
                    end
                    cn = cn + 1;
                    %Swtich Off
                    Cal_Names{1,1}{cn,1} = cal_data{1,3}{ii,2};
                    str_id = findstr(cal_data{1,3}{ii,2},'_');
                    str_unit = Cal_Names{1,1}{cn,1}(str_id(end)+1:end);
                    str_dec = Cal_Names{1,1}{cn,1}(str_id(2)+1:str_id(end)-1);
                    Ids = strcmpi(str_unit,key_str(:,3));
                    verify_Id = find(Ids);
                    if ~isempty(verify_Id)
                        Unit_Names_Cal{1,1}{cn,1} = key_str{verify_Id,1};
                        Value_Names_Cal{1,1}{cn,1} = ' ';
                        Min_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,4});
                        Max_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,5});
                        Type_Names_Cal{1,1}{cn,1} = key_str{verify_Id,6};
                        Dec_Names_Cal{1,1}{cn,1} = str_dec;
                    else
                        Unit_Names_Cal{1,1}{cn,1} = ' ';
                        Value_Names_Cal{1,1}{cn,1} = ' ';
                        Min_Names_Cal{1,1}{cn,1} = ' ';
                        Max_Names_Cal{1,1}{cn,1} = ' ';
                        Type_Names_Cal{1,1}{cn,1} = ' ';
                        Dec_Names_Cal{1,1}{cn,1} = ' ';
                    end
                    cn = cn + 1;
                end
            end
            %Look_Up 1D
            if ~isempty(cal_data{1,4})
                len_1ds = size(cal_data{1,4});
                len_1d = len_1ds(1,1);
                for ii = 1:len_1d
                    %Input1 of 1_Dim MAP
                    Cal_Names{1,1}{cn,1} = cal_data{1,4}{ii,1};
                    str_id = findstr(cal_data{1,4}{ii,1},'_');
                    str_unit = Cal_Names{1,1}{cn,1}(str_id(end)+1:end);
                    str_dec = Cal_Names{1,1}{cn,1}(str_id(2)+1:str_id(end)-1);
                    Ids = strcmpi(str_unit,key_str(:,3));
                    verify_Id = find(Ids);
                    if ~isempty(verify_Id)
                        Unit_Names_Cal{1,1}{cn,1} = key_str{verify_Id,1};
                        Value_Names_Cal{1,1}{cn,1} = ' ';
                        Min_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,4});
                        Max_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,5});
                        Type_Names_Cal{1,1}{cn,1} = key_str{verify_Id,6};
                        Dec_Names_Cal{1,1}{cn,1} = str_dec;
                    else
                        Unit_Names_Cal{1,1}{cn,1} = ' ';
                        Value_Names_Cal{1,1}{cn,1} = ' ';
                        Min_Names_Cal{1,1}{cn,1} = ' ';
                        Max_Names_Cal{1,1}{cn,1} = ' ';
                        Type_Names_Cal{1,1}{cn,1} = ' ';
                        Dec_Names_Cal{1,1}{cn,1} = ' ';
                    end
                    cn = cn + 1;
                    %Output of 1_Dim MAP
                    Cal_Names{1,1}{cn,1} = cal_data{1,4}{ii,2};
                    str_id = findstr(cal_data{1,4}{ii,2},'_');
                    str_unit = Cal_Names{1,1}{cn,1}(str_id(end)+1:end);
                    str_dec = Cal_Names{1,1}{cn,1}(str_id(2)+1:str_id(end)-1);
                    Ids = strcmpi(str_unit,key_str(:,3));
                    verify_Id = find(Ids);
                    if ~isempty(verify_Id)
                        Unit_Names_Cal{1,1}{cn,1} = key_str{verify_Id,1};
                        Value_Names_Cal{1,1}{cn,1} = ' ';
                        Min_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,4});
                        Max_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,5});
                        Type_Names_Cal{1,1}{cn,1} = key_str{verify_Id,6};
                        Dec_Names_Cal{1,1}{cn,1} = str_dec;
                    else
                        Unit_Names_Cal{1,1}{cn,1} = ' ';
                        Value_Names_Cal{1,1}{cn,1} = ' ';
                        Min_Names_Cal{1,1}{cn,1} = ' ';
                        Max_Names_Cal{1,1}{cn,1} = ' ';
                        Type_Names_Cal{1,1}{cn,1} = ' ';
                        Dec_Names_Cal{1,1}{cn,1} = ' ';
                    end
                    cn = cn + 1;
                end
            end
            %Look_Up 2D
            if ~isempty(cal_data{1,5})
                len_2ds = size(cal_data{1,5});
                len_2d = len_2ds(1,1);
                for ii = 1:len_2d
                    %Input1 of 2_Dim MAP X
                    Cal_Names{1,1}{cn,1} = cal_data{1,5}{ii,1};
                    str_id = findstr(cal_data{1,5}{ii,1},'_');
                    str_unit = Cal_Names{1,1}{cn,1}(str_id(end)+1:end);
                    str_dec = Cal_Names{1,1}{cn,1}(str_id(2)+1:str_id(end)-1);
                    Ids = strcmpi(str_unit,key_str(:,3));
                    verify_Id = find(Ids);
                    if ~isempty(verify_Id)
                        Unit_Names_Cal{1,1}{cn,1} = key_str{verify_Id,1};
                        Value_Names_Cal{1,1}{cn,1} = ' ';
                        Min_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,4});
                        Max_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,5});
                        Type_Names_Cal{1,1}{cn,1} = key_str{verify_Id,6};
                        Dec_Names_Cal{1,1}{cn,1} = str_dec;
                    else
                        Unit_Names_Cal{1,1}{cn,1} = ' ';
                        Value_Names_Cal{1,1}{cn,1} = ' ';
                        Min_Names_Cal{1,1}{cn,1} = ' ';
                        Max_Names_Cal{1,1}{cn,1} = ' ';
                        Type_Names_Cal{1,1}{cn,1} = ' ';
                        Dec_Names_Cal{1,1}{cn,1} = ' ';
                    end
                    cn = cn + 1;
                    %Input2 of 2_Dim MAP Y
                    Cal_Names{1,1}{cn,1} = cal_data{1,5}{ii,2};
                    str_id = findstr(cal_data{1,5}{ii,2},'_');
                    str_unit = Cal_Names{1,1}{cn,1}(str_id(end)+1:end);
                    str_dec = Cal_Names{1,1}{cn,1}(str_id(2)+1:str_id(end)-1);
                    Ids = strcmpi(str_unit,key_str(:,3));
                    verify_Id = find(Ids);
                    if ~isempty(verify_Id)
                        Unit_Names_Cal{1,1}{cn,1} = key_str{verify_Id,1};
                        Value_Names_Cal{1,1}{cn,1} = ' ';
                        Min_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,4});
                        Max_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,5});
                        Type_Names_Cal{1,1}{cn,1} = key_str{verify_Id,6};
                        Dec_Names_Cal{1,1}{cn,1} = str_dec;
                    else
                        Unit_Names_Cal{1,1}{cn,1} = ' ';
                        Value_Names_Cal{1,1}{cn,1} = ' ';
                        Min_Names_Cal{1,1}{cn,1} = ' ';
                        Max_Names_Cal{1,1}{cn,1} = ' ';
                        Type_Names_Cal{1,1}{cn,1} = ' ';
                        Dec_Names_Cal{1,1}{cn,1} = ' ';
                    end
                    cn = cn + 1;
                    %Output of 2_Dim MAP Z
                    Cal_Names{1,1}{cn,1} = cal_data{1,5}{ii,3};
                    str_id = findstr(cal_data{1,5}{ii,3},'_');
                    str_unit = Cal_Names{1,1}{cn,1}(str_id(end)+1:end);
                    str_dec = Cal_Names{1,1}{cn,1}(str_id(2)+1:str_id(end)-1);
                    Ids = strcmpi(str_unit,key_str(:,3));
                    verify_Id = find(Ids);
                    if ~isempty(verify_Id)
                        Unit_Names_Cal{1,1}{cn,1} = key_str{verify_Id,1};
                        Value_Names_Cal{1,1}{cn,1} = ' ';
                        Min_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,4});
                        Max_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,5});
                        Type_Names_Cal{1,1}{cn,1} = key_str{verify_Id,6};
                        Dec_Names_Cal{1,1}{cn,1} = str_dec;
                    else
                        Unit_Names_Cal{1,1}{cn,1} = ' ';
                        Value_Names_Cal{1,1}{cn,1} = ' ';
                        Min_Names_Cal{1,1}{cn,1} = ' ';
                        Max_Names_Cal{1,1}{cn,1} = ' ';
                        Type_Names_Cal{1,1}{cn,1} = ' ';
                        Dec_Names_Cal{1,1}{cn,1} = ' ';
                    end
                    cn = cn + 1;
                end
            end
            %Interval
            if ~isempty(cal_data{1,6})
                len_intervals = size(cal_data{1,6});
                len_interval = len_intervals(1,1);
                for ii = 1:len_interval
                    %Upper limit
                    Cal_Names{1,1}{cn,1} = cal_data{1,6}{ii,1};
                    str_id = findstr(cal_data{1,6}{ii,1},'_');
                    str_unit = Cal_Names{1,1}{cn,1}(str_id(end)+1:end);
                    str_dec = Cal_Names{1,1}{cn,1}(str_id(2)+1:str_id(end)-1);
                    Ids = strcmpi(str_unit,key_str(:,3));
                    verify_Id = find(Ids);
                    if ~isempty(verify_Id)
                        Unit_Names_Cal{1,1}{cn,1} = key_str{verify_Id,1};
                        Value_Names_Cal{1,1}{cn,1} = ' ';
                        Min_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,4});
                        Max_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,5});
                        Type_Names_Cal{1,1}{cn,1} = key_str{verify_Id,6};
                        Dec_Names_Cal{1,1}{cn,1} = str_dec;
                    else
                        Unit_Names_Cal{1,1}{cn,1} = ' ';
                        Value_Names_Cal{1,1}{cn,1} = ' ';
                        Min_Names_Cal{1,1}{cn,1} = ' ';
                        Max_Names_Cal{1,1}{cn,1} = ' ';
                        Type_Names_Cal{1,1}{cn,1} = ' ';
                        Dec_Names_Cal{1,1}{cn,1} = ' ';
                    end
                    cn = cn + 1;
                    %Lower limit
                    Cal_Names{1,1}{cn,1} = cal_data{1,6}{ii,2};
                    str_id = findstr(cal_data{1,6}{ii,2},'_');
                    str_unit = Cal_Names{1,1}{cn,1}(str_id(end)+1:end);
                    str_dec = Cal_Names{1,1}{cn,1}(str_id(2)+1:str_id(end)-1);
                    Ids = strcmpi(str_unit,key_str(:,3));
                    verify_Id = find(Ids);
                    if ~isempty(verify_Id)
                        Unit_Names_Cal{1,1}{cn,1} = key_str{verify_Id,1};
                        Value_Names_Cal{1,1}{cn,1} = ' ';
                        Min_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,4});
                        Max_Names_Cal{1,1}{cn,1} = num2str(key_str{verify_Id,5});
                        Type_Names_Cal{1,1}{cn,1} = key_str{verify_Id,6};
                        Dec_Names_Cal{1,1}{cn,1} = str_dec;
                    else
                        Unit_Names_Cal{1,1}{cn,1} = ' ';
                        Value_Names_Cal{1,1}{cn,1} = ' ';
                        Min_Names_Cal{1,1}{cn,1} = ' ';
                        Max_Names_Cal{1,1}{cn,1} = ' ';
                        Type_Names_Cal{1,1}{cn,1} = ' ';
                        Dec_Names_Cal{1,1}{cn,1} = ' ';
                    end
                    cn = cn + 1;
                end
            end
            All_Cal_Name{1,1} = cat(2,Cal_Names{1,1},Value_Names_Cal{1,1},Unit_Names_Cal{1,1},Min_Names_Cal{1,1},Max_Names_Cal{1,1},Type_Names_Cal{1,1},Dec_Names_Cal{1,1});
            Rag_Cal_Name{1,1} = ['A3:G' num2str(cn+1)];
            %         else
            %             All_Cal_Name{1,1} = {'','','','','','',''};
            %             Rag_Cal_Name{1,1} = ['A3:G3'];
        end
        %------------------------------Measures---------------------------%
        Sub_Name{2,1} = sig_data{2,1};
        Rag_Sub_Name{2,1} = ['A' num2str(n+2) ':F' num2str(n+2)];
        Rag_Format{2,1} = ['A' num2str(n+3) ':F' num2str(n+3)];
        for ii = 1:length(sig_data{2,2})
            Sig_Names{2,1}{nn,1} = sig_data{2,2}{ii,1};
            str_id = findstr(sig_data{2,2}{ii,1},'_');
            str_unit = Sig_Names{2,1}{nn,1}((str_id(end)+1):end);
            str_dec = Sig_Names{2,1}{nn,1}((str_id(2)+1):(str_id(end)-1));
            Ids = strcmpi(str_unit,key_str(:,3));
            verify_Id = find(Ids);
            if ~isempty(verify_Id)
                Unit_Names{2,1}{nn,1} = key_str{verify_Id,1};
                Min_Names{2,1}{nn,1} = num2str(key_str{verify_Id,4});
                Max_Names{2,1}{nn,1} = num2str(key_str{verify_Id,5});
                Type_Names{2,1}{nn,1} = key_str{verify_Id,6};
                Dec_Names{2,1}{nn,1} = str_dec;
            else
                Unit_Names{2,1}{nn,1} = 'tbd';
                Min_Names{2,1}{nn,1} = 'tbd';
                Max_Names{2,1}{nn,1} = 'tbd';
                Type_Names{2,1}{nn,1} = 'tbd';
                Dec_Names{2,1}{nn,1} = 'tbd';
            end
            nn = nn + 1;
        end
        if ~isempty(Sig_Names)
            All_Sig_Name{2,1} = cat(2,Sig_Names{2,1},Unit_Names{2,1},Min_Names{2,1},Max_Names{2,1},Type_Names{2,1},Dec_Names{2,1});
            Rag_Sig_Name{2,1} = ['A' num2str(n+4) ':F' num2str(n+4+nn-2)];
        end
        % -------------------------------Calibration--------------------------%
        % Identify parameters type:constant/relay/Lookup1/lookup2/Interval
        cal_flg = 0;
        if ~isempty(cal_data{2,2})||~isempty(cal_data{2,3})||~isempty(cal_data{2,4})||~isempty(cal_data{2,5})||~isempty(cal_data{2,6})
            cal_flg = 1;
            Sub_Name_Cal{2,1} = cal_data{2,1};
            Rag_Sub_Name_Cal{2,1} = ['A' num2str(cn+2) ':G' num2str(cn+2)];
            Rag_Format_Cal{2,1} = ['A' num2str(cn+3) ':G' num2str(cn+3)];
            %Constants
            if ~isempty(cal_data{2,2})
                for ii = 1:length(cal_data{2,2})
                    Cal_Names{2,1}{cnn,1} = cal_data{2,2}{ii,1};
                    str_id = findstr(cal_data{2,2}{ii,1},'_');
                    str_unit = Cal_Names{2,1}{cnn,1}(str_id(end)+1:end);
                    str_dec = Cal_Names{2,1}{cnn,1}(str_id(2)+1:str_id(end)-1);
                    Ids = strcmpi(str_unit,key_str(:,3));
                    verify_Id = find(Ids);
                    if ~isempty(verify_Id)
                        Unit_Names_Cal{2,1}{cnn,1} = key_str{verify_Id,1};
                        Value_Names_Cal{2,1}{cnn,1} = ' ';
                        Min_Names_Cal{2,1}{cnn,1} = num2str(key_str{verify_Id,4});
                        Max_Names_Cal{2,1}{cnn,1} = num2str(key_str{verify_Id,5});
                        Type_Names_Cal{2,1}{cnn,1} = key_str{verify_Id,6};
                        Dec_Names_Cal{2,1}{cnn,1} = str_dec;
                    else
                        Unit_Names_Cal{2,1}{cnn,1} = ' ';
                        Value_Names_Cal{2,1}{cnn,1} = ' ';
                        Min_Names_Cal{2,1}{cnn,1} = ' ';
                        Max_Names_Cal{2,1}{cnn,1} = ' ';
                        Type_Names_Cal{2,1}{cnn,1} = ' ';
                        Dec_Names_Cal{2,1}{cnn,1} = ' ';
                    end
                    cnn = cnn + 1;
                end
            end
            %Relays
            if ~isempty(cal_data{2,3})
                len_relays = size(cal_data{2,3});
                len_relay = len_relays(1,1);
                for ii = 1:len_relay
                    %Switch On
                    Cal_Names{2,1}{cnn,1} = cal_data{2,3}{ii,1};
                    str_id = findstr(cal_data{2,3}{ii,1},'_');
                    str_unit = Cal_Names{2,1}{cnn,1}(str_id(end)+1:end);
                    str_dec = Cal_Names{2,1}{cnn,1}(str_id(2)+1:str_id(end)-1);
                    Ids = strcmpi(str_unit,key_str(:,3));
                    verify_Id = find(Ids);
                    if ~isempty(verify_Id)
                        Unit_Names_Cal{2,1}{cnn,1} = key_str{verify_Id,1};
                        Value_Names_Cal{2,1}{cnn,1} = ' ';
                        Min_Names_Cal{2,1}{cnn,1} = num2str(key_str{verify_Id,4});
                        Max_Names_Cal{2,1}{cnn,1} = num2str(key_str{verify_Id,5});
                        Type_Names_Cal{2,1}{cnn,1} = key_str{verify_Id,6};
                        Dec_Names_Cal{2,1}{cnn,1} = str_dec;
                    else
                        Unit_Names_Cal{2,1}{cnn,1} = ' ';
                        Value_Names_Cal{2,1}{cnn,1} = ' ';
                        Min_Names_Cal{2,1}{cnn,1} = ' ';
                        Max_Names_Cal{2,1}{cnn,1} = ' ';
                        Type_Names_Cal{2,1}{cnn,1} = ' ';
                        Dec_Names_Cal{2,1}{cnn,1} = ' ';
                    end
                    cnn = cnn + 1;
                    %Swtich Off
                    Cal_Names{2,1}{cnn,1} = cal_data{2,3}{ii,2};
                    str_id = findstr(cal_data{2,3}{ii,2},'_');
                    str_unit = Cal_Names{2,1}{cnn,1}(str_id(end)+1:end);
                    str_dec = Cal_Names{2,1}{cnn,1}(str_id(2)+1:str_id(end)-1);
                    Ids = strcmpi(str_unit,key_str(:,3));
                    verify_Id = find(Ids);
                    if ~isempty(verify_Id)
                        Unit_Names_Cal{2,1}{cnn,1} = key_str{verify_Id,1};
                        Value_Names_Cal{2,1}{cnn,1} = ' ';
                        Min_Names_Cal{2,1}{cnn,1} = num2str(key_str{verify_Id,4});
                        Max_Names_Cal{2,1}{cnn,1} = num2str(key_str{verify_Id,5});
                        Type_Names_Cal{2,1}{cnn,1} = key_str{verify_Id,6};
                        Dec_Names_Cal{2,1}{cnn,1} = str_dec;
                    else
                        Unit_Names_Cal{2,1}{cnn,1} = ' ';
                        Value_Names_Cal{2,1}{cnn,1} = ' ';
                        Min_Names_Cal{2,1}{cnn,1} = ' ';
                        Max_Names_Cal{2,1}{cnn,1} = ' ';
                        Type_Names_Cal{2,1}{cnn,1} = ' ';
                        Dec_Names_Cal{2,1}{cnn,1} = ' ';
                    end
                    cnn = cnn + 1;
                end
            end
            %Look_Up 1D
            if ~isempty(cal_data{2,4})
                len_1ds = size(cal_data{2,4});
                len_1d = len_1ds(1,1);
                for ii = 1:len_1d
                    %Input1 of 1_Dim MAP
                    Cal_Names{2,1}{cnn,1} = cal_data{2,4}{ii,1};
                    str_id = findstr(cal_data{2,4}{ii,1},'_');
                    str_unit = Cal_Names{2,1}{cnn,1}(str_id(end)+1:end);
                    str_dec = Cal_Names{2,1}{cnn,1}(str_id(2)+1:str_id(end)-1);
                    Ids = strcmpi(str_unit,key_str(:,3));
                    verify_Id = find(Ids);
                    if ~isempty(verify_Id)
                        Unit_Names_Cal{2,1}{cnn,1} = key_str{verify_Id,1};
                        Value_Names_Cal{2,1}{cnn,1} = ' ';
                        Min_Names_Cal{2,1}{cnn,1} = num2str(key_str{verify_Id,4});
                        Max_Names_Cal{2,1}{cnn,1} = num2str(key_str{verify_Id,5});
                        Type_Names_Cal{2,1}{cnn,1} = key_str{verify_Id,6};
                        Dec_Names_Cal{2,1}{cnn,1} = str_dec;
                    else
                        Unit_Names_Cal{2,1}{cnn,1} = ' ';
                        Value_Names_Cal{2,1}{cnn,1} = ' ';
                        Min_Names_Cal{2,1}{cnn,1} = ' ';
                        Max_Names_Cal{2,1}{cnn,1} = ' ';
                        Type_Names_Cal{2,1}{cnn,1} = ' ';
                        Dec_Names_Cal{2,1}{cnn,1} = ' ';
                    end
                    cnn = cnn + 1;
                    %Output of 1_Dim MAP
                    Cal_Names{2,1}{cnn,1} = cal_data{2,4}{ii,2};
                    str_id = findstr(cal_data{2,4}{ii,2},'_');
                    str_unit = Cal_Names{2,1}{cnn,1}(str_id(end)+1:end);
                    str_dec = Cal_Names{2,1}{cnn,1}(str_id(2)+1:str_id(end)-1);
                    Ids = strcmpi(str_unit,key_str(:,3));
                    verify_Id = find(Ids);
                    if ~isempty(verify_Id)
                        Unit_Names_Cal{2,1}{cnn,1} = key_str{verify_Id,1};
                        Value_Names_Cal{2,1}{cnn,1} = ' ';
                        Min_Names_Cal{2,1}{cnn,1} = num2str(key_str{verify_Id,4});
                        Max_Names_Cal{2,1}{cnn,1} = num2str(key_str{verify_Id,5});
                        Type_Names_Cal{2,1}{cnn,1} = key_str{verify_Id,6};
                        Dec_Names_Cal{2,1}{cnn,1} = str_dec;
                    else
                        Unit_Names_Cal{2,1}{cnn,1} = ' ';
                        Value_Names_Cal{2,1}{cnn,1} = ' ';
                        Min_Names_Cal{2,1}{cnn,1} = ' ';
                        Max_Names_Cal{2,1}{cnn,1} = ' ';
                        Type_Names_Cal{2,1}{cnn,1} = ' ';
                        Dec_Names_Cal{2,1}{cnn,1} = ' ';
                    end
                    cnn = cnn + 1;
                end
            end
            %Look_Up 2D
            if ~isempty(cal_data{2,5})
                len_2ds = size(cal_data{2,5});
                len_2d = len_2ds(1,1);
                for ii = 1:len_2d
                    %Input1 of 2_Dim MAP X
                    Cal_Names{2,1}{cnn,1} = cal_data{2,5}{ii,1};
                    str_id = findstr(cal_data{2,5}{ii,1},'_');
                    str_unit = Cal_Names{2,1}{cnn,1}(str_id(end)+1:end);
                    str_dec = Cal_Names{2,1}{cnn,1}(str_id(2)+1:str_id(end)-1);
                    Ids = strcmpi(str_unit,key_str(:,3));
                    verify_Id = find(Ids);
                    if ~isempty(verify_Id)
                        Unit_Names_Cal{2,1}{cnn,1} = key_str{verify_Id,1};
                        Value_Names_Cal{2,1}{cnn,1} = ' ';
                        Min_Names_Cal{2,1}{cnn,1} = num2str(key_str{verify_Id,4});
                        Max_Names_Cal{2,1}{cnn,1} = num2str(key_str{verify_Id,5});
                        Type_Names_Cal{2,1}{cnn,1} = key_str{verify_Id,6};
                        Dec_Names_Cal{2,1}{cnn,1} = str_dec;
                    else
                        Unit_Names_Cal{2,1}{cnn,1} = ' ';
                        Value_Names_Cal{2,1}{cnn,1} = ' ';
                        Min_Names_Cal{2,1}{cnn,1} = ' ';
                        Max_Names_Cal{2,1}{cnn,1} = ' ';
                        Type_Names_Cal{2,1}{cnn,1} = ' ';
                        Dec_Names_Cal{2,1}{cnn,1} = ' ';
                    end
                    cnn = cnn + 1;
                    %Input2 of 2_Dim MAP Y
                    Cal_Names{2,1}{cnn,1} = cal_data{2,5}{ii,2};
                    str_id = findstr(cal_data{2,5}{ii,2},'_');
                    str_unit = Cal_Names{2,1}{cnn,1}(str_id(end)+1:end);
                    str_dec = Cal_Names{2,1}{cnn,1}(str_id(2)+1:str_id(end)-1);
                    Ids = strcmpi(str_unit,key_str(:,3));
                    verify_Id = find(Ids);
                    if ~isempty(verify_Id)
                        Unit_Names_Cal{2,1}{cnn,1} = key_str{verify_Id,1};
                        Value_Names_Cal{2,1}{cnn,1} = ' ';
                        Min_Names_Cal{2,1}{cnn,1} = num2str(key_str{verify_Id,4});
                        Max_Names_Cal{2,1}{cnn,1} = num2str(key_str{verify_Id,5});
                        Type_Names_Cal{2,1}{cnn,1} = key_str{verify_Id,6};
                        Dec_Names_Cal{2,1}{cnn,1} = str_dec;
                    else
                        Unit_Names_Cal{2,1}{cnn,1} = ' ';
                        Value_Names_Cal{2,1}{cnn,1} = ' ';
                        Min_Names_Cal{2,1}{cnn,1} = ' ';
                        Max_Names_Cal{2,1}{cnn,1} = ' ';
                        Type_Names_Cal{2,1}{cnn,1} = ' ';
                        Dec_Names_Cal{2,1}{cnn,1} = ' ';
                    end
                    cnn = cnn + 1;
                    %Output of 2_Dim MAP Z
                    Cal_Names{2,1}{cnn,1} = cal_data{2,5}{ii,3};
                    str_id = findstr(cal_data{2,5}{ii,3},'_');
                    str_unit = Cal_Names{2,1}{cnn,1}(str_id(end)+1:end);
                    str_dec = Cal_Names{2,1}{cnn,1}(str_id(2)+1:str_id(end)-1);
                    Ids = strcmpi(str_unit,key_str(:,3));
                    verify_Id = find(Ids);
                    if ~isempty(verify_Id)
                        Unit_Names_Cal{2,1}{cnn,1} = key_str{verify_Id,1};
                        Value_Names_Cal{2,1}{cnn,1} = ' ';
                        Min_Names_Cal{2,1}{cnn,1} = num2str(key_str{verify_Id,4});
                        Max_Names_Cal{2,1}{cnn,1} = num2str(key_str{verify_Id,5});
                        Type_Names_Cal{2,1}{cnn,1} = key_str{verify_Id,6};
                        Dec_Names_Cal{2,1}{cnn,1} = str_dec;
                    else
                        Unit_Names_Cal{2,1}{cnn,1} = ' ';
                        Value_Names_Cal{2,1}{cnn,1} = ' ';
                        Min_Names_Cal{2,1}{cnn,1} = ' ';
                        Max_Names_Cal{2,1}{cnn,1} = ' ';
                        Type_Names_Cal{2,1}{cnn,1} = ' ';
                        Dec_Names_Cal{2,1}{cnn,1} = ' ';
                    end
                    cnn = cnn + 1;
                end
            end
            %Invertval
            if ~isempty(cal_data{2,6})
                len_invertvals = size(cal_data{2,6});
                len_invertval = len_invertvals(1,1);
                for ii = 1:len_invertval
                    %Upper limit
                    Cal_Names{2,1}{cnn,1} = cal_data{2,6}{ii,1};
                    str_id = findstr(cal_data{2,6}{ii,1},'_');
                    str_unit = Cal_Names{2,1}{cnn,1}(str_id(end)+1:end);
                    str_dec = Cal_Names{2,1}{cnn,1}(str_id(2)+1:str_id(end)-1);
                    Ids = strcmpi(str_unit,key_str(:,3));
                    verify_Id = find(Ids);
                    if ~isempty(verify_Id)
                        Unit_Names_Cal{2,1}{cnn,1} = key_str{verify_Id,1};
                        Value_Names_Cal{2,1}{cnn,1} = ' ';
                        Min_Names_Cal{2,1}{cnn,1} = num2str(key_str{verify_Id,4});
                        Max_Names_Cal{2,1}{cnn,1} = num2str(key_str{verify_Id,5});
                        Type_Names_Cal{2,1}{cnn,1} = key_str{verify_Id,6};
                        Dec_Names_Cal{2,1}{cnn,1} = str_dec;
                    else
                        Unit_Names_Cal{2,1}{cnn,1} = ' ';
                        Value_Names_Cal{2,1}{cnn,1} = ' ';
                        Min_Names_Cal{2,1}{cnn,1} = ' ';
                        Max_Names_Cal{2,1}{cnn,1} = ' ';
                        Type_Names_Cal{2,1}{cnn,1} = ' ';
                        Dec_Names_Cal{2,1}{cnn,1} = ' ';
                    end
                    cnn = cnn + 1;
                    %Lower limit
                    Cal_Names{2,1}{cnn,1} = cal_data{2,6}{ii,2};
                    str_id = findstr(cal_data{2,6}{ii,2},'_');
                    str_unit = Cal_Names{2,1}{cnn,1}(str_id(end)+1:end);
                    str_dec = Cal_Names{2,1}{cnn,1}(str_id(2)+1:str_id(end)-1);
                    Ids = strcmpi(str_unit,key_str(:,3));
                    verify_Id = find(Ids);
                    if ~isempty(verify_Id)
                        Unit_Names_Cal{2,1}{cnn,1} = key_str{verify_Id,1};
                        Value_Names_Cal{2,1}{cnn,1} = ' ';
                        Min_Names_Cal{2,1}{cnn,1} = num2str(key_str{verify_Id,4});
                        Max_Names_Cal{2,1}{cnn,1} = num2str(key_str{verify_Id,5});
                        Type_Names_Cal{2,1}{cnn,1} = key_str{verify_Id,6};
                        Dec_Names_Cal{2,1}{cnn,1} = str_dec;
                    else
                        Unit_Names_Cal{2,1}{cnn,1} = ' ';
                        Value_Names_Cal{2,1}{cnn,1} = ' ';
                        Min_Names_Cal{2,1}{cnn,1} = ' ';
                        Max_Names_Cal{2,1}{cnn,1} = ' ';
                        Type_Names_Cal{2,1}{cnn,1} = ' ';
                        Dec_Names_Cal{2,1}{cnn,1} = ' ';
                    end
                    cnn = cnn + 1;
                end
            end
            All_Cal_Name{2,1} = cat(2,Cal_Names{2,1},Value_Names_Cal{2,1},Unit_Names_Cal{2,1},Min_Names_Cal{2,1},Max_Names_Cal{2,1},Type_Names_Cal{2,1},Dec_Names_Cal{2,1});
            Rag_Cal_Name{2,1} = ['A' num2str(cn+4) ':G' num2str(cn+4+cnn-2)];
            %         else
            %             All_Cal_Name{2,1} = {'','','','','','',''};
            %             Rag_Cal_Name{2,1} = ['A3:G3'];
        end
    else len==3
        Sub_Name{1,1} = sig_data{1,1};
        Rag_Sub_Name{1,1} = ['A1:F1'];
        Rag_Format{1,1} = ['A2:F2'];
        Sig_Names = {};
        for ii = 1:length(sig_data{1,2})
            Sig_Names{1,1}{n,1} = sig_data{1,2}{ii,1};
            str_id = findstr(sig_data{1,2}{ii,1},'_');
            str_unit = Sig_Names{1,1}{n,1}((str_id(end)+1):end);
            str_dec = Sig_Names{1,1}{n,1}((str_id(2)+1):(str_id(end)-1));
            Ids = strcmpi(str_unit,key_str(:,3));
            verify_Id = find(Ids);
            if ~isempty(verify_Id)
                Unit_Names{1,1}{n,1} = key_str{verify_Id,1};
                Min_Names{1,1}{n,1} = num2str(key_str{verify_Id,4});
                Max_Names{1,1}{n,1} = num2str(key_str{verify_Id,5});
                Type_Names{1,1}{n,1} = key_str{verify_Id,6};
                Dec_Names{1,1}{n,1} = str_dec;
            else
                Unit_Names{1,1}{n,1} = 'tbd';
                Min_Names{1,1}{n,1} = 'tbd';
                Max_Names{1,1}{n,1} = 'tbd';
                Type_Names{1,1}{n,1} = 'tbd';
                Dec_Names{1,1}{n,1} = 'tbd';
            end
            n = n + 1;
        end
        if ~isempty(Sig_Names)
            All_Sig_Name{1,1}= cat(2,Sig_Names{1,1},Unit_Names{1,1},Min_Names{1,1},Max_Names{1,1},Type_Names{1,1},Dec_Names{1,1});
            Rag_Sig_Name{1,1} = ['A3:F' num2str(n+1)];
        end
        
        Sub_Name{2,1} = sig_data{2,1};
        Rag_Sub_Name{2,1} = ['A' num2str(n+2) ':F' num2str(n+2)];
        Rag_Format{2,1} = ['A' num2str(n+3) ':F' num2str(n+3)];
        for ii = 1:length(sig_data{2,2})
            Sig_Names{2,1}{nn,1} = sig_data{2,2}{ii,1};
            str_id = findstr(sig_data{2,2}{ii,1},'_');
            str_unit = Sig_Names{2,1}{nn,1}((str_id(end)+1):end);
            str_dec = Sig_Names{2,1}{nn,1}((str_id(2)+1):(str_id(end)-1));
            Ids = strcmpi(str_unit,key_str(:,3));
            verify_Id = find(Ids);
            if ~isempty(verify_Id)
                Unit_Names{2,1}{nn,1} = key_str{verify_Id,1};
                Min_Names{2,1}{nn,1} = num2str(key_str{verify_Id,4});
                Max_Names{2,1}{nn,1} = num2str(key_str{verify_Id,5});
                Type_Names{2,1}{nn,1} = key_str{verify_Id,6};
                Dec_Names{2,1}{nn,1} = str_dec;
            else
                Unit_Names{2,1}{nn,1} = 'tbd';
                Min_Names{2,1}{nn,1} = 'tbd';
                Max_Names{2,1}{nn,1} = 'tbd';
                Type_Names{2,1}{nn,1} = 'tbd';
                Dec_Names{2,1}{nn,1} = 'tbd';
            end
            nn = nn + 1;
        end
        if ~isempty(Sig_Names)
            All_Sig_Name{2,1} = cat(2,Sig_Names{2,1},Unit_Names{2,1},Min_Names{2,1},Max_Names{2,1},Type_Names{2,1},Dec_Names{2,1});
            Rag_Sig_Name{2,1} = ['A' num2str(n+4) ':F' num2str(n+4+nn-2)];
        end
        
        Sub_Name{3,1} = sig_data{3,1};
        Rag_Sub_Name{3,1} = ['A' num2str(n+4+nn-2+1) ':F' num2str(n+4+nn-2+1)];
        Rag_Format{3,1} = ['A' num2str(n+4+nn-2+2) ':F' num2str(n+4+nn-2+2)];
        for ii = 1:length(sig_data{3,2})
            Sig_Names{3,1}{nnn,1} = sig_data{3,2}{ii,1};
            str_id = findstr(sig_data{3,2}{ii,1},'_');
            str_unit = Sig_Names{3,1}{nnn,1}((str_id(end)+1):end);
            str_dec = Sig_Names{3,1}{nnn,1}((str_id(2)+1):(str_id(end)-1));
            Ids = strcmpi(str_unit,key_str(:,3));
            verify_Id = find(Ids);
            if ~isempty(verify_Id)
                Unit_Names{3,1}{nnn,1} = key_str{verify_Id,1};
                Min_Names{3,1}{nnn,1} = num2str(key_str{verify_Id,4});
                Max_Names{3,1}{nnn,1} = num2str(key_str{verify_Id,5});
                Type_Names{3,1}{nnn,1} = key_str{verify_Id,6};
                Dec_Names{3,1}{nnn,1} = str_dec;
            else
                Unit_Names{3,1}{nnn,1} = 'tbd';
                Min_Names{3,1}{nnn,1} = 'tbd';
                Max_Names{3,1}{nnn,1} = 'tbd';
                Type_Names{3,1}{nnn,1} = 'tbd';
                Dec_Names{3,1}{nnn,1} = 'tbd';
            end
            nnn = nnn + 1;
        end
        if ~isempty(Sig_Names)
            All_Sig_Name{3,1} = cat(2,Sig_Names{3,1},Unit_Names{3,1},Min_Names{3,1},Max_Names{3,1},Type_Names{3,1},Dec_Names{3,1});
            Rag_Sig_Name{3,1} = ['A' num2str(n+4+nn-2+2+1) ':F' num2str(n+4+nn-2+2+nnn-2)];
        end
    end   
end

% Call the API of Excel
Excel = actxserver('excel.application');

% Excel.visible=1;
wb=Excel.WorkBooks.Add(1);
Sheets = Excel.ActiveWorkbook.Sheets;
% Sheets = Workbook.Sheets;
%Define the format of Measures
Format_Str = {'Signals Name','Unit','Min','Max','Data Type','Description'};
%Define the format of Calibrations
Format_Str1 = {'Signals Name','Value','Unit','Min','Max','Data Type','Description'};
%Add the sheet of Excel and named them
Sheet_Names= {'Measures';'Parameters'};
for n = 1:(length(Sheet_Names)-1)
    Sheets.Add;
end
for n = 1:length(Sheet_Names)
    Sheets.Item(n).Name = Sheet_Names{n,1};
end
%-------------------------------------sheet1:Measure----------------------%
%Cell Column Width Config
Meas_Sheet = Sheets.Item(1);
Meas_Sheet.Range('A1:A1').ColumnWidth = 35;
Meas_Sheet.Range('B1:B1').ColumnWidth = 9;
Meas_Sheet.Range('C1:C1').ColumnWidth = 9;
Meas_Sheet.Range('D1:D1').ColumnWidth = 9;
Meas_Sheet.Range('E1:E1').ColumnWidth = 9;
Meas_Sheet.Range('F1:F1').ColumnWidth = 76;
%Add Signals to Excel Cell
for i = 1:len
    %---------------------------Subsystem Name display--------------------%
    Sub_Name_Config= Excel.Activesheet.get('Range',Rag_Sub_Name{i,1});
    Sub_Name_Config.Font.name = 'Calibri';
    Sub_Name_Config.Font.size = 12;
    Sub_Name_Config.Font.bold = 1;
    Sub_Name_Config.Borders.Weight = 2;
    %Sub_Name_Config.Borders.ColorIndex = 3;
    Sub_Name_Config.HorizontalAlignment = 3;
    Sub_Name_Config.MergeCells=1;
    Sub_Name_Config.value = {Sub_Name{i,1}};
    Sub_Name_Config.interior.Color=hex2dec('c67c10');
    Sub_Name_Config.font.Color=hex2dec('000000');
    %-------------------------------Measure Attributes--------------------%
    Format_Name_Config= Excel.Activesheet.get('Range',Rag_Format{i,1});
    Format_Name_Config.Font.name = 'Calibri';
    Format_Name_Config.Font.size = 11;
    Format_Name_Config.Font.bold = 1;
    Format_Name_Config.Borders.Weight = 2;
    Format_Name_Config.HorizontalAlignment = 1;
    Format_Name_Config.value = Format_Str;
    Format_Name_Config.interior.Color=hex2dec('ffffff');
    Format_Name_Config.font.Color=hex2dec('000000');
    %--------------------------------Signals Display----------------------%
    if ~isempty(Sig_Names)
        Signals_Config= Excel.Activesheet.get('Range',Rag_Sig_Name{i,1});
        Signals_Config.Font.name = 'Calibri';
        Signals_Config.Font.size = 10;
        Signals_Config.Font.bold = 0;
        Signals_Config.Borders.Weight = 2;
        Signals_Config.value = All_Sig_Name{i,1};
        Signals_Config.HorizontalAlignment = 1;
        Signals_Config.interior.Color=hex2dec('ffffff');
        Signals_Config.font.Color=hex2dec('000000');
    end
end

%-----------------------------------sheet2:Parameter----------------------%
%Cell Column Width Config
Parm_Sheet = Sheets.Item(2);
Parm_Sheet.Range('A1:A1').ColumnWidth = 35;
Parm_Sheet.Range('B1:B1').ColumnWidth = 46;
Parm_Sheet.Range('C1:C1').ColumnWidth = 9;
Parm_Sheet.Range('D1:D1').ColumnWidth = 9;
Parm_Sheet.Range('E1:E1').ColumnWidth = 9;
Parm_Sheet.Range('F1:F1').ColumnWidth = 9;
Parm_Sheet.Range('G1:G1').ColumnWidth = 76;
for i = 1:len
    cals_len = length(Rag_Sub_Name_Cal);
    %---------------------------Subsystem Cal Name display--------------------%
    if ~isempty(Rag_Sub_Name_Cal{i,1})&&(len == cals_len)
        Sub_Name_Config_Cal= Parm_Sheet.get('Range',Rag_Sub_Name_Cal{i,1});
        Sub_Name_Config_Cal.Font.name = 'Calibri';
        Sub_Name_Config_Cal.Font.size = 12;
        Sub_Name_Config_Cal.Font.bold = 1;
        Sub_Name_Config_Cal.Borders.Weight = 2;
        %Sub_Name_Config.Borders.ColorIndex = 3;
        Sub_Name_Config_Cal.HorizontalAlignment = 3;
        Sub_Name_Config_Cal.MergeCells=1;
        Sub_Name_Config_Cal.value = {Sub_Name_Cal{i,1}};
        Sub_Name_Config_Cal.interior.Color=hex2dec('04d231');
        Sub_Name_Config_Cal.font.Color=hex2dec('000000');
        %-------------------------------Cal Attributes--------------------%
        Sub_Name_Config_Cal= Parm_Sheet.get('Range',Rag_Format_Cal{i,1});
        Sub_Name_Config_Cal.Font.name = 'Calibri';
        Sub_Name_Config_Cal.Font.size = 11;
        Sub_Name_Config_Cal.Font.bold = 1;
        Sub_Name_Config_Cal.Borders.Weight = 2;
        Sub_Name_Config_Cal.HorizontalAlignment = 1;
        Sub_Name_Config_Cal.value = Format_Str1;
        Sub_Name_Config_Cal.interior.Color=hex2dec('ffffff');
        Sub_Name_Config_Cal.font.Color=hex2dec('000000');
        %--------------------------------Cals Display----------------------%
        Cals_Config= Parm_Sheet.get('Range',Rag_Cal_Name{i,1});
        Cals_Config.Font.name = 'Calibri';
        Cals_Config.Font.size = 10;
        Cals_Config.Font.bold = 0;
        Cals_Config.Borders.Weight = 2;
        Cals_Config.value = All_Cal_Name{i,1};
        Cals_Config.HorizontalAlignment = 1;
        Cals_Config.interior.Color=hex2dec('ffffff');
        Cals_Config.font.Color=hex2dec('000000');
    else if(~isempty(Rag_Sub_Name_Cal{i,1}))&&(cals_len == 1);    %Current Model only one subsystem have cal
        Sub_Name_Config_Cal= Parm_Sheet.get('Range',Rag_Sub_Name_Cal{i,1});
        Sub_Name_Config_Cal.Font.name = 'Calibri';
        Sub_Name_Config_Cal.Font.size = 12;
        Sub_Name_Config_Cal.Font.bold = 1;
        Sub_Name_Config_Cal.Borders.Weight = 2;
        %Sub_Name_Config.Borders.ColorIndex = 3;
        Sub_Name_Config_Cal.HorizontalAlignment = 3;
        Sub_Name_Config_Cal.MergeCells=1;
        Sub_Name_Config_Cal.value = {Sub_Name_Cal{1,1}};
        Sub_Name_Config_Cal.interior.Color=hex2dec('04d231');
        Sub_Name_Config_Cal.font.Color=hex2dec('000000');
        %-------------------------------Cal Attributes--------------------%
        Sub_Name_Config_Cal= Parm_Sheet.get('Range',Rag_Format_Cal{1,1});
        Sub_Name_Config_Cal.Font.name = 'Calibri';
        Sub_Name_Config_Cal.Font.size = 11;
        Sub_Name_Config_Cal.Font.bold = 1;
        Sub_Name_Config_Cal.Borders.Weight = 2;
        Sub_Name_Config_Cal.HorizontalAlignment = 1;
        Sub_Name_Config_Cal.value = Format_Str1;
        Sub_Name_Config_Cal.interior.Color=hex2dec('ffffff');
        Sub_Name_Config_Cal.font.Color=hex2dec('000000');
        %--------------------------------Cals Display----------------------%
        Cals_Config= Parm_Sheet.get('Range',Rag_Cal_Name{1,1});
        Cals_Config.Font.name = 'Calibri';
        Cals_Config.Font.size = 10;
        Cals_Config.Font.bold = 0;
        Cals_Config.Borders.Weight = 2;
        Cals_Config.value = All_Cal_Name{1,1};
        Cals_Config.HorizontalAlignment = 1;
        Cals_Config.interior.Color=hex2dec('ffffff');
        Cals_Config.font.Color=hex2dec('000000');
        end
    end
end

% ran_sub1.Range(Excel_Range11).WrapText= 1; %自动换行
% invoke(Excel.Selection.Rows,'Autofit');%自动调整单元格大小
% %----------------------------------
file = fullfile(pwd, [bdroot,'_signals']);
wb.SaveAs(file);
wb.Close;
Excel.Quit;
Excel.delete;
%clear all;
disp(['Convert to ',bdroot,'_signals Finished!']);
% else
%     disp('No Loading');
% end
end