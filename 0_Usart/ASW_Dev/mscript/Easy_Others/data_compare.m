function data_compare
global results_data f_row_col;
results_data = {};
results_dots = {};
f_row_col = {};
n = 1;
% set_param('ACC_ModeManager_Test','SimulationCommand','start')
data_time = evalin('base','data_time');
%Sampale time dots
time_dots = data_time(2:end,1);
%Output data of target
data_dots = data_time(1,2:end);

for i = 1:length(time_dots)
    for ii = 1:length(data_dots)
        sig_name = data_dots{1,ii};
        sig_data_tar = num2str(data_time{i+1,ii+1});
        sig_str = [sig_name '_Result'];%Simulation Resutls signal name
        sig_str1 = evalin('base',sig_str);
        time_dot = time_dots{i,1};
        id = (time_dot+0.01)/0.01;
        id_str = num2str(id);
        id_num = str2num(id_str);
        data = get(sig_str1,'Data');%Simulation Results signal data
        data_result = num2str(data(id_num,1));%Sample dot Results signal data
        %the results data
        results_data{i,ii} = data_result;
        if sig_data_tar==data_result
            results_dots{i,ii} = 'Pass';
        else
            results_dots{i,ii} = 'NoPass';
            f_row_col{n,1} = i;
            f_row_col{n,2} = ii;
            n = n + 1;
        end
    end
end
% set_param('my_model','StartFcn','openscopes')
% assignin('base', 'results_data', results_data);
% assignin('base', 'results_dots', results_dots);
excel_name = evalin('base','excel_name');
results_to_excel(excel_name);
end
function results_to_excel(filename)
global results_data f_row_col num ;
indx = evalin('base','indx');%Need Manual Input the indx；
num = evalin('base','num');
inports = evalin('base','inports');
outports = evalin('base','outports');
data_time = evalin('base','data_time');
Excel = actxserver('Excel.Application');
Excel.Visible = 0;
FileArchive = invoke(Excel.Workbooks, 'open', filename);
Sheets = Excel.ActiveWorkBook.Sheets;
ran_sub = Sheets.Item(indx);
ran_sub.Activate;
%Layout of data
row_len = length(inports);
out_len = length(outports);

%Output Actual No. display
[out_1] = xlscellid(2,row_len+out_len+4);
[out_2] = xlscellid(2,row_len+out_len+4-1+out_len);
ran_output = [out_1 ':' out_2];
ran_sub.Range(ran_output).ColumnWidth = 3.5;
ran_sub.Range(ran_output).Font.name = 'Calibri';
ran_sub.Range(ran_output).Font.size = 10;
ran_sub.Range(ran_output).Font.bold = 1;
ran_sub.Range(ran_output).Borders.Weight = 1;
ran_sub.Range(ran_output).HorizontalAlignment = 1;
ran_sub.Range(ran_output).VerticalAlignment = 3;
for ii = 1:out_len
    outportnum{ii,1} = num2str(ii);
end
ran_sub.Range(ran_output).value = outportnum';
ran_sub.Range(ran_output).HorizontalAlignment = 3;

%Output Signals display
[out_1_s] = xlscellid(3,row_len+out_len+4);
[out_2_s] = xlscellid(3,row_len+out_len+4-1+out_len);
ran_output_s = [out_1_s ':' out_2_s];
ran_sub.Range(ran_output_s).Font.name = 'Calibri';
ran_sub.Range(ran_output_s).Font.size = 10;
ran_sub.Range(ran_output_s).Font.bold = 0;
ran_sub.Range(ran_output_s).Borders.Weight = 1;
ran_sub.Range(ran_output_s).HorizontalAlignment = 1;
ran_sub.Range(ran_output_s).VerticalAlignment = 3;
ran_sub.Range(ran_output_s).value = outports';
ran_sub.Range(ran_output_s).Orientation = 90; %向上旋转文字
ran_sub.Range(ran_output_s).HorizontalAlignment = 3;

%The Output title display
[out_title_1] = xlscellid(1,row_len+out_len+4);
[out_title_2] = xlscellid(1,row_len+out_len+4-1+out_len);
ran_title_out = [out_title_1 ':' out_title_2];
ran_sub.Range(ran_title_out).MergeCells = 1;
ran_sub.Range(ran_title_out).Font.name = 'Calibri';
ran_sub.Range(ran_title_out).Font.size = 10;
ran_sub.Range(ran_title_out).Font.bold = 1;
ran_sub.Range(ran_title_out).Borders.Weight = 1;
ran_sub.Range(ran_title_out).HorizontalAlignment = 1;
ran_sub.Range(ran_title_out).VerticalAlignment = 3;
ran_sub.Range(ran_title_out).value = 'O_A';
ran_sub.Range(ran_title_out).HorizontalAlignment = 3;

%Data Display
[out_data1] = xlscellid(4,row_len+out_len+4);
[out_data2] = xlscellid(2+length(data_time),row_len+out_len+4-1+out_len);
ran_data_out = [out_data1 ':' out_data2];
ran_sub.Range(ran_data_out).Font.name = 'Calibri';
ran_sub.Range(ran_data_out).Font.size = 10;
ran_sub.Range(ran_data_out).Font.bold = 0;
ran_sub.Range(ran_data_out).Borders.Weight = 1;
ran_sub.Range(ran_data_out).HorizontalAlignment = 1;
ran_sub.Range(ran_data_out).VerticalAlignment = 3;
ran_sub.Range(ran_data_out).value = results_data;
ran_sub.Range(ran_data_out).HorizontalAlignment = 3;
ran_sub.Range(ran_data_out).interior.Color=hex2dec('44db0f');%背景色
if ~isempty(f_row_col)
    for k = 1:length(f_row_col(:,1))
        cal_row = 3+ f_row_col{k,1};
        cal_col = row_len+out_len+4-1+f_row_col{k,2};
        [row_col] = xlscellid(cal_row,cal_col);
        flt_pos = [row_col ':' row_col];
        ran_sub.Range(flt_pos).interior.Color=hex2dec('0503fc');%背景色
    end
end

pre_filename = evalin('base','pre_filename');
rename_str = strfind(filename,'\');
cur_filename = [filename(1:rename_str(end)) 'TC' num2str(indx) '_Result.xlsx'];
if strcmp(pre_filename,cur_filename)
    num = num + 1;
    assignin('base','num',num);
    cur_filename = [filename(1:rename_str(end)) 'TC' num2str(indx) '_Result' num2str(num) '.xlsx'];
else
    cur_filename = [filename(1:rename_str(end)) 'TC' num2str(indx) '_Result.xlsx'];
end

%invoke(FileArchive,'delete',filename);
invoke(FileArchive,'SaveAs',cur_filename);
assignin('base','pre_filename',cur_filename);
%Excel.SaveAs([filename '_Result']);
invoke(FileArchive,'close');
invoke(Excel, 'quit');
release(FileArchive);
delete(Excel);

%the resulat excel process
% Excel = actxserver('Excel.Application');
% Excel.Visible = 0;
% FileArchive = invoke(Excel.Workbooks, 'open', cur_filename);
% Sheets = Excel.ActiveWorkBook.Sheets;
% nSheets = Sheets.Count;
% for kk = 1:nSheets
%     if kk ~= indx
%         id_sheet = ['TC0' num2str(kk)];
%         Sheets.Item(id_sheet).Delete;%删除工作表
%     end
% end
% invoke(FileArchive,'close');
% invoke(Excel, 'quit');
% release(FileArchive);
% delete(Excel);

return;
end

function [cellid] = xlscellid(row,col)
% function [cellid] = xlscellid(row,col)
%
% Given a row and col in an xls sheet convert it to a cellid of the form AA1.
% Columns from A to ZZ supported
persistent colhead % Cellarray containing excel column headings upto ZZ
if isempty(colhead)
    acol='ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    n=1;
    for i=1:length(acol)
        colhead{n} = acol(i);
        n=n+1;
    end
    for i=1:length(acol)
        for j=1:length(acol)
            colhead{n}= [ acol(i) acol(j) ];
            n=n+1;
        end
    end
    clear n
end

if col < 1 || col > length(colhead)
    cellid=sprintf('??%d',row);
    warning('Column %d passed to xlscellid is out of bounds', col);
else
    cellid=sprintf('%s%d',colhead{col},row);
end
end