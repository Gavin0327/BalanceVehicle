function updatecase
ii = 1;
%模型仿真结束回调
set_param(0, 'CallbackTracing', 'off');
set_param(gcbh,'StopFcn','data_compare');
%测试用例更新
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
%TestCaseSelector
[indx,tf] = listdlg('ListString',sheetnames,'Name','Test Case Selector','ListSize',[250,250]);
assignin('base','indx',indx);
if length(indx)==1
    fprintf('* Reading %s\n',sheetnames{indx});
    sheetdata=getfield(test_struct,sheetnames{indx},'sheetdata');
    %获取输入信号
    signals = sheetdata(3,2:end);
    for i = 1:length(signals)
        if ~ischar(signals{1,i})
            space_id{ii,1} = i;
            ii = ii + 1;
        end
    end
    inports = sheetdata(3,2:space_id{1,1});
    outports = sheetdata(3,space_id{1,1}+2:end);
    assignin('base','inports',inports);
    assignin('base','outports',outports);
    
    data_value = sheetdata(4:end,2:space_id{1,1});%Input Data
    data_value_OutTar = sheetdata(4:end,space_id{1,1}+2:end);%Output Data
    data_table = cell2table(data_value);
    %获取时间值
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
    for i = 1:length(inports)
        inport_name = inports{1,i};
        %data_value处理
        valuestr = ['iscell(data_table.data_value',num2str(i),')'];%Don't Use table also can complete the judgement
        if eval(valuestr) %通过iscell返回的枚举类变量是1
            enumstr = strrep(data_value(:,i),'''','');%将枚举信号前后的引号去掉
            enums = char(enumstr);
            cur_value = str2num(enums);%string type convert to enum type
            value_str = ['TestCase.',inport_name,'.signals.values','=','cur_value;'];
            eval(value_str);
            dimstr = ['TestCase.',inport_name,'.signals.dimensions','= 1;'];
            eval(dimstr);
            timestr = ['TestCase.',inport_name,'.time = time_value;'];
            eval(timestr);
        else %非枚举类数据返回
            cur_value = cell2mat(data_value(:,i));%Select double
            value_str = ['TestCase.',inport_name,'.signals.values','=','cur_value;'];
            eval(value_str);
            dimstr = ['TestCase.',inport_name,'.signals.dimensions','= 1;'];
            eval(dimstr);
            timestr = ['TestCase.',inport_name,'.time = time_value;'];
            eval(timestr);
        end
    end
    assignin('base','TestCase',TestCase);
else
    warning('Please Select the TestCase!');
end
end

function [xlsdata] = read_data(xlsfile)
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