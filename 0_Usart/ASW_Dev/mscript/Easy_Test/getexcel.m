function getexcel
%模型仿真结束回调
% set_param(0, 'CallbackTracing', 'off');
% set_param(gcbh,'StopFcn','data_compare');
%仿真模型及用例导入
unit_name = evalin('base','unit_name');
Test_Model_Name = [unit_name,'_Test'];
[file,path] = uigetfile('*.xlsx');
if isequal(file,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,file)]);
end
excel_name = fullfile(path,file);
assignin('base','excel_name',excel_name);
[test_struct] = read_data(fullfile(path,file));
sheetnames = fields(test_struct); % get names of worksheets from xlsdata
% Read the data from each sheet into a test structure.
for i=1:length(sheetnames)
    fprintf('*--------------------------------------\n');
    fprintf('* Reading %s\n',sheetnames{i});
    fprintf('*--------------------------------------\n');
    % for each worksheet, get the raw xls data from the xlsdata struct
    sheetdata=getfield(test_struct,sheetnames{i},'sheetdata');
end
%获取输入信号
% inports = sheetdata(3,2:end);
signals = sheetdata(3,2:end);
for i = 1:length(signals)
    if ~ischar(signals{1,i})
        space_id = i;
    end
end
inports = sheetdata(3,2:space_id);
outports = sheetdata(3,space_id+2:end);
assignin('base','inports',inports);
assignin('base','outports',outports);
    
data_value = sheetdata(4:end,2:space_id);%Input Data
data_value_OutTar = sheetdata(4:end,space_id+2:end);%Output Data
data_table = cell2table(data_value);

time_value_org = sheetdata(4:end,1);
time_value = cell2mat(time_value_org);
time_value = time_value';
stop_time = time_value(1,end);
assignin('base','stop_time',stop_time);
    %期望数据与时间同步
    data_tar = cat(1,outports,data_value_OutTar);
    time_str = cat(1,{'time'},time_value_org);
    data_time = cat(2,time_str,data_tar);
    assignin('base','data_time',data_time);
%建立Test case subsystem
unit_pos = get_param([Test_Model_Name,'/',unit_name,'_Val'],'position');
subname = [Test_Model_Name,'/TestCase'];
subsys=add_block('simulink/Ports & Subsystems/Subsystem',subname,'Position',[-325 unit_pos(1,2) -140 unit_pos(1,4)],'ForegroundColor','Blue','DropShadow','on');
del_sumsub1 = [subname,'/In1'];
del_sumsub2 = [subname,'/Out1'];
delete_line(subname,'In1/1','Out1/1');
delete_block(del_sumsub1);
delete_block(del_sumsub2);
for i = 1:length(inports)
    conname = [subname,'/','convert_',num2str(i)];
    inport_name = inports{1,i};
    outname = [subname,'/',inport_name];
    wkname = [subname,'/','wk_',num2str(i)];
    %data_value处理
    valuestr = ['iscell(data_table.data_value',num2str(i),')'];%Don't Use table also can complete the judgement
    if eval(valuestr);
        enumstr = strrep(data_value(:,i),'''','');%Select Enum
        enums = char(enumstr);
        cur_value = str2num(enums);%string type convert to enum type
        value_str = ['TestCase.',inport_name,'.signals.values','=','cur_value;'];
        eval(value_str);
        dimstr = ['TestCase.',inport_name,'.signals.dimensions','= 1;'];
        eval(dimstr);
        timestr = ['TestCase.',inport_name,'.time = time_value;'];
        eval(timestr);
        %gen moddel
        add_block('simulink/Sources/From Workspace',wkname,'Position',[540  168+30*i  730 182+30*i],'VariableName',['TestCase.',inport_name],...
            'ShowName','off','OutputAfterFinalValue','Holding final value','BackgroundColor','green','SampleTime','-1','Interpolate','off');%2019.0918:FromWorksapce输出数据配置为保持
    else
        cur_value = cell2mat(data_value(:,i));%Select double
        value_str = ['TestCase.',inport_name,'.signals.values','=','cur_value;'];
        eval(value_str);
        dimstr = ['TestCase.',inport_name,'.signals.dimensions','= 1;'];
        eval(dimstr);
        timestr = ['TestCase.',inport_name,'.time = time_value;'];
        eval(timestr);
        %gen moddel
        add_block('simulink/Sources/From Workspace',wkname,'Position',[540  168+30*i  730 182+30*i],'VariableName',['TestCase.',inport_name],...
            'ShowName','off','OutputAfterFinalValue','Holding final value','BackgroundColor','green','SampleTime','-1');%2019.0918:FromWorksapce输出数据配置为保持
    end
    
    add_block('simulink/Signal Attributes/Data Type Conversion',conname,'Position',[830  168+30*i  980 182+30*i],'ShowName','off');
    add_block('simulink/Sinks/Out1',outname,'Position',[1210 168+30*i  1240 182+30*i]);
    r1 = ['wk_',num2str(i),'/1'];
    r2 = ['convert_',num2str(i),'/1'];
    r3 = [inport_name,'/1'];
    add_line(subname,{r1},{r2},'autorouting','on');
    lineP = add_line(subname,{r2},{r3} ,'autorouting','on');
    LineName = inport_name;
    set_param(lineP,'Name',LineName);
    Simulink.sdi.markSignalForStreaming(lineP,'on');%打开Stream记录
end
assignin('base','TestCase',TestCase);
% Connect line
for i = 1:length(inports)
    r1 = ['TestCase','/',num2str(i)];
    r2 = [unit_name,'_Val','/',num2str(i)];
    add_line(Test_Model_Name,{r1},{r2},'autorouting','on');
end
set_param(subsys,'position',[-325 unit_pos(1,2) -140 unit_pos(1,4)]);

%Build Test Results subsystem
subname1 = [Test_Model_Name,'/TestResults'];
subsys1=add_block('simulink/Ports & Subsystems/Subsystem',subname1,'Position',[755 unit_pos(1,2) 940 unit_pos(1,4)],'ForegroundColor','Blue','DropShadow','on');
del_sumsub1 = [subname1,'/In1'];
del_sumsub2 = [subname1,'/Out1'];
delete_line(subname1,'In1/1','Out1/1');
delete_block(del_sumsub1);
delete_block(del_sumsub2);
outputsignals = evalin('base','outputsignals');
for i = 1:length(outputsignals)
    conname = [subname1,'/','convert_',num2str(i)];
    inport_name = outputsignals{i,1};
    outname = [subname1,'/',inport_name];
    wkname = [subname1,'/','wk_',num2str(i)];
    %data_value处理
    add_block('simulink/Sources/In1',outname,'Position',[300  168+30*i  340 182+30*i],'ShowName','on');
    add_block('simulink/Sinks/To Workspace',wkname,'Position',[540  168+30*i  730 182+30*i],'VariableName',[inport_name,'_Result'],...
        'ShowName','off','SaveFormat','Timeseries','SampleTime','-1');
    r1 = [inport_name,'/1'];
    r2 = ['wk_',num2str(i),'/1'];
    lineP = add_line(subname1,{r1},{r2},'autorouting','on');
    LineName = [inport_name,'_Result'];
    set_param(lineP,'Name',LineName);
    Simulink.sdi.markSignalForStreaming(lineP,'on');%打开Stream记录
end
% Connect line
for i = 1:length(outputsignals)
r1 = [unit_name,'_Val','/',num2str(i)];
r2 = ['TestResults','/',num2str(i)];
add_line(Test_Model_Name,{r1},{r2},'autorouting','on');
end
set_param(subsys1,'position',[755 unit_pos(1,2) 940 unit_pos(1,4)]);
end


function [xlsdata] = read_data(xlsfile)
%'F:\2_HA12B\11_V2XDep\0_To_Do\2_SencondPhase\sw\test\mil\util\Data.xlsx';
Excel = actxserver('Excel.Application');
Excel.Visible = 0;
FileArchive = invoke(Excel.Workbooks, 'open', xlsfile);

Sheets = Excel.ActiveWorkBook.Sheets;
nSheets = Sheets.Count;

for i = 1:nSheets
    
    target_sheet = Sheets.Item(i);
    target_sheet.Activate;
    Activesheet = Excel.Activesheet;
    sheetname=Activesheet.Name;
    if strfind(sheetname,' ')
        invoke(Excel, 'quit');
        release(FileArchive);
        delete(Excel);
        fprintf('Error: sheet name ''%s'' contains spaces.\n',sheetname);
        readfailed=1;
        return;
    end
    
    
    try
        UsedRange = get(Activesheet,'UsedRange');
        sheetdata = UsedRange.value; % get whole of used range as a cell matrix
        release(UsedRange);
    catch ErrObj
        warning(ErrObj.message);
        invoke(FileArchive,'save');
        invoke(Excel, 'quit');
        release(FileArchive);
        delete(Excel);
        fprintf('Error reading XLS Sheet: %s.',sheetname);
        readfailed=1;
        return;
    end
    
    if ~isempty(sheetdata)
        nrows=size(sheetdata,1);
        ncols=size(sheetdata,2);
        for r=1:nrows
            for c=1:ncols
                if iscellstr(sheetdata{r,c})
                    fprintf('%s', sheetdata{r,c});
                end
                %                     if isnan(sheetdata{r,c})
                %                         sheetdata{r,c}=[];
                %                     end
            end
        end
        
        % write raw xls data for this sheet into returned xlsdata
        % structure
        eval(sprintf('xlsdata.%s.sheetdata=sheetdata;',sheetname));
    end
end
invoke(FileArchive,'close');
invoke(Excel, 'quit');
release(FileArchive);
delete(Excel);
return;
end