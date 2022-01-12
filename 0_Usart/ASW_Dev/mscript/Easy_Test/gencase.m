function [slx_path] = gencase(pathname,testpath,current_path)
% pathname = 'vcu_arch/VSL__VCU_Strategy_Layer/VCS__VCU_Control_Strategy/SCOO__Speed_Coordinator/OBU_OnBoardUnit';
% help：背景色设置、字体颜色设置、字体角度设置  
    %     ran_sub.Range('A1:A1').interior.Color=hex2dec('00ffff');%背景色
    %     ran_sub.Range('A1:A1').font.Color=hex2dec('000000');%字体色
    %     ran_sub.Range('A1:A1').Orientation = 90;
main_path = which(mfilename);
path = fileparts(main_path);
[inputsiganls,outputsignals,unit_name,slx_path,fodername]=UnitValidation(pathname,testpath);
assignin('base','unit_name',unit_name);
assignin('base','outputsignals',outputsignals);
%cd(current_path);
%% Creat Excel Test Case
file_name = [fodername,'_TestCase'];
file = fullfile(slx_path, file_name);
assignin('base','TestCasePath',file);
%Excel API 调用
Excel = actxserver('excel.application');
%打开Excel
Excel.visible=0;
%生成Excel文件
wb=Excel.WorkBooks.Add();
%Sheet页名称修改
Sheets = Excel.ActiveWorkbook.Sheets;    % Sheets = Workbook.Sheets;
nSheets = Sheets.Count;
for i=1:length(nSheets)
    test_name = ['TC0',num2str(i)];
    Sheets.Item(i).Name = test_name;
    
    ran_sub = Sheets.Item(i);
    ran_sub.Activate;
    %% Input Dispaly
    % Port No. info dispaly
    dispran = ['A2:A2'];
    ran_sub.Range(dispran).ColumnWidth = 8;
    ran_sub.Range(dispran).Font.name = 'Calibri';
    ran_sub.Range(dispran).Font.size = 10;
    ran_sub.Range(dispran).Font.bold = 1;
    ran_sub.Range(dispran).Borders.Weight = 1;
    ran_sub.Range(dispran).HorizontalAlignment = 1;
    ran_sub.Range(dispran).VerticalAlignment = 3;
    ran_sub.Range(dispran).value = {'PortNo.'};
    %Input No
    row_len = length(inputsiganls);
    [row_lenstr] = xlscellid(2,row_len+1);
    ran_input = ['B2:',row_lenstr];
    ran_sub.Range(ran_input).ColumnWidth = 3.5;
    ran_sub.Range(ran_input).Font.name = 'Calibri';
    ran_sub.Range(ran_input).Font.size = 10;
    ran_sub.Range(ran_input).Font.bold = 1;
    ran_sub.Range(ran_input).Borders.Weight = 1;
    ran_sub.Range(ran_input).HorizontalAlignment = 1;
    ran_sub.Range(ran_input).VerticalAlignment = 3;
    for ii = 1:row_len
        inportnum{ii,1} = num2str(ii);
    end
    ran_sub.Range(ran_input).value = inportnum';
    ran_sub.Range(ran_input).HorizontalAlignment = 3;
    % Time display
    time_rag = ['A3:A3'];
%     ran_sub.Range(time_rag).ColumnWidth = 8;
    ran_sub.Range(time_rag).Font.name = 'Calibri';
    ran_sub.Range(time_rag).Font.size = 10;
    ran_sub.Range(time_rag).Font.bold = 1;
    ran_sub.Range(time_rag).Borders.Weight = 1;
    ran_sub.Range(time_rag).HorizontalAlignment = 1;
    ran_sub.Range(time_rag).VerticalAlignment = 3;
    ran_sub.Range(time_rag).value = {'Time'};
    %Input Signals Name Display
    [row_lenstr1] = xlscellid(3,row_len+1);
    ran_input1 = ['B3:',row_lenstr1];
    ran_sub.Range(ran_input1).ColumnWidth = 3.5;
    ran_sub.Range(ran_input1).Font.name = 'Calibri';
    ran_sub.Range(ran_input1).Font.size = 10;
    ran_sub.Range(ran_input1).Font.bold = 0;
    ran_sub.Range(ran_input1).Borders.Weight = 1;
    ran_sub.Range(ran_input1).HorizontalAlignment = 1;
    ran_sub.Range(ran_input1).VerticalAlignment = 3;
    ran_sub.Range(ran_input1).value = inputsiganls';
    ran_sub.Range(ran_input1).Orientation = 90; %向上旋转文字
    ran_sub.Range(ran_input1).HorizontalAlignment = 3;
    %The Input title display
    [title_len] = xlscellid(1,row_len+1);
    ran_title = ['B1:',title_len];
    ran_sub.Range(ran_title).MergeCells = 1;
    %ran_sub.Range(ran_title).ColumnWidth = 3.88;
    ran_sub.Range(ran_title).Font.name = 'Calibri';
    ran_sub.Range(ran_title).Font.size = 10;
    ran_sub.Range(ran_title).Font.bold = 1;
    ran_sub.Range(ran_title).Borders.Weight = 1;
    ran_sub.Range(ran_title).HorizontalAlignment = 1;
    ran_sub.Range(ran_title).VerticalAlignment = 3;
    ran_sub.Range(ran_title).value = 'Input';
    ran_sub.Range(ran_title).HorizontalAlignment = 3;
    %% Output Target and Actual Value Display
    %Output No. Display
    out_len = length(outputsignals);
    [out_1] = xlscellid(2,row_len+3);
    [out_2] = xlscellid(2,row_len+3+out_len-1);
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
    [out_1_s] = xlscellid(3,row_len+3);
    [out_2_s] = xlscellid(3,row_len+3+out_len-1);
    ran_output_s = [out_1_s ':' out_2_s];
    %ran_sub.Range(ran_output_s).ColumnWidth = 3.88;
    ran_sub.Range(ran_output_s).Font.name = 'Calibri';
    ran_sub.Range(ran_output_s).Font.size = 10;
    ran_sub.Range(ran_output_s).Font.bold = 0;
    ran_sub.Range(ran_output_s).Borders.Weight = 1;
    ran_sub.Range(ran_output_s).HorizontalAlignment = 1;
    ran_sub.Range(ran_output_s).VerticalAlignment = 3;
    ran_sub.Range(ran_output_s).value = outputsignals';
    ran_sub.Range(ran_output_s).Orientation = 90; %向上旋转文字
    ran_sub.Range(ran_output_s).HorizontalAlignment = 3;
    %The Output title display
    [out_title_1] = xlscellid(1,row_len+3);
    [out_title_2] = xlscellid(1,row_len+3+out_len-1);
    ran_title_out = [out_title_1 ':' out_title_2];
    ran_sub.Range(ran_title_out).MergeCells = 1;
    %ran_sub.Range(ran_title_out).ColumnWidth = 3.88;
    ran_sub.Range(ran_title_out).Font.name = 'Calibri';
    ran_sub.Range(ran_title_out).Font.size = 10;
    ran_sub.Range(ran_title_out).Font.bold = 1;
    ran_sub.Range(ran_title_out).Borders.Weight = 1;
    ran_sub.Range(ran_title_out).HorizontalAlignment = 1;
    ran_sub.Range(ran_title_out).VerticalAlignment = 3;
    ran_sub.Range(ran_title_out).value = 'O_T';
    ran_sub.Range(ran_title_out).HorizontalAlignment = 3;
end
wb.SaveAs(file);
wb.Close;
Excel.Quit;
Excel.delete;
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
%% 仿真模型建立
function  [mode_name_in,mode_name_out,unit_name,slx_path,fodername]=UnitValidation(pathname,testpath)
file_path = which(mfilename);
% path = fileparts(file_path);
path = testpath;
unit_path=pathname;
strID = strfind(unit_path,'/');
if isempty(strID)
unit_name = pathname;
else
unit_name = unit_path(strID(end)+1:end);%根据模块名命名验证模型名
end
str={};
%Model Name Check
Model_Path_Str = gcs;
Str_Id = strfind(Model_Path_Str,'/');
if isempty(Str_Id)
Model_Top_Name =  pathname;   
else
Model_Top_Name = Model_Path_Str(1:Str_Id(1,1)-1);
end
if strcmp(Model_Top_Name,unit_name)
    Unit_Name_Val = [Model_Top_Name,'_copy'];
else
    Unit_Name_Val = unit_name;
end
% assignin('base','Unit_Name_Val',Unit_Name_Val);
%验证用模型命名
Test_Model_Name = [unit_name,'_Test'];
%判断是否重复建立
filemsg = dir(path);
for i = 1:length(filemsg) 
    Name{i,1} = filemsg(i).name;
    str{i,1} = strfind(filemsg(i).name,unit_name);%确定某一模块建立的次数
end
contname = length(cell2mat(str));
fodername = [unit_name,'_Test',num2str(contname+1)];

%建立存放模型的文件夹
base_path = fodername;
slx_path = [path,'\',base_path];
mkdir(slx_path);
addpath(slx_path);
cd(slx_path);
assignin('base','foderpath',slx_path);
new_system(Unit_Name_Val);
open_system(Unit_Name_Val);
MiLTestConfig(Unit_Name_Val);
new_system(Test_Model_Name);
open_system(Test_Model_Name);
MiLTestConfig(Test_Model_Name);
subname = [Test_Model_Name,'/',unit_name,'_Val'];
Fcnname = [Test_Model_Name,'/','Fcn'];
assignin('base','Data_Souce_Name',Test_Model_Name);
assignin('base','ValPath',subname);
% MiLTestConfig(name);
subsys = add_block('simulink/Ports & Subsystems/Model', subname);
save_system(Unit_Name_Val);
% 复制子系统到模块图
Simulink.SubSystem.copyContentsToBlockDiagram(unit_path, Unit_Name_Val);
set_param(subsys,'ModelName',Unit_Name_Val);
%取消信号关联，防止仿真时报错
Del_Resolve(Unit_Name_Val);
%读取策略模型输入端口（不含任务调度）
M_In_path = find_system(Unit_Name_Val, 'SearchDepth', 1,'BlockType', 'Inport');
Sprit_ID = strfind(M_In_path{1,1},'/');
mode_name_in = {};
for i=1:length(M_In_path)
    buf = M_In_path{i,1};
    mode_name_in{i,1} = buf(Sprit_ID+1:end);
end
len_in = length(mode_name_in);
%读取策略模型输出端口
M_Out_path = find_system(Unit_Name_Val, 'SearchDepth', 1,'BlockType', 'Outport');
Sprit_ID = strfind(M_Out_path{1,1},'/');
mode_name_out = {};
for i=1:length(M_Out_path)
    buf = M_Out_path{i,1};
    mode_name_out{i,1} = buf(Sprit_ID+1:end);
end
len_out = length(mode_name_out);
%判断是否还有任务调度模块
ref_model_input = get_param(subname,'InputSignalNames');
len_ref = length(ref_model_input);
if len_in==len_ref %无任务调度模块
    if len_in>=len_out
        bot = 212+len_in*20+30;
    else
        bot = 212+len_out*20+30;
    end
else %有调度模块
    if len_in>=len_out
        bot = 212+len_in*30+30;
    else
        bot = 212+len_out*30+30;
    end
Fcn = add_block('simulink/Ports & Subsystems/Function-Call Generator', Fcnname,'Position',[50 139 70 161]); 
h= get_param(Fcnname,'PortHandles');
h1= get_param(subname,'PortHandles');
add_line(Test_Model_Name,h.Outport(1),h1.Trigger(1),'autorouting','on');
set_param(Fcn,'sample_time','0.01');
end
set_param(subsys,'position',[50 212 565 bot],'BackgroundColor','orange','DropShadow','on'); %source position [-440 212 -210 bot]
end
