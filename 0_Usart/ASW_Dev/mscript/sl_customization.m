function sl_customization(cm)
% sl_refresh_customizations
%% Register custom menu function.
cm.addCustomMenuFcn('Simulink:MenuBar', @getMyMenuItems);
end

function schemaFcns = getMyMenuItems(callbackInfo)
schemaFcns = {@m1};
end

function schema = m1(callbackInfo)
schema = sl_container_schema;
schema.label = 'DevTool';
schema.childrenFcns = {@CalDisp,@EasyModel,@ToExcel,@FromExcel,@MILTest};
end
%% Define the schema function for first menu item.
function schema = CalDisp(callbackInfo)
schema = sl_action_schema;
schema.label = 'Cal Disp';
schema.userdata = '';
schema.callback = @mapdisp;
end
function schema = EasyModel(callbackInfo)
schema = sl_action_schema;
schema.label = 'Easy Model';
schema.userdata = '';
schema.callback = @easymodel;
end
function schema = ToExcel(callbackInfo)
schema = sl_action_schema;
schema.label = 'Goto Excel';
schema.userdata = '';
schema.callback = @myCallback1;
end
function schema = FromExcel(callbackInfo)
schema = sl_action_schema;
schema.label = 'From Excel';
schema.userdata = '';
schema.callback = @myCallback2;
end
function schema = MILTest(callbackInfo)
schema = sl_container_schema;
schema.label = 'MIL Test';
schema.userdata = '';
schema.childrenFcns = {@EditTC, @UnitTest,@UpdateTC};
%schema.callback = @myCallback3;
end
function [y]=mapdisp(x)
global GUI
x = 1;
y=1;
ver_valid = '(R2014b)';
v = ver;
s_ver = v(1).Release;

block_name = {'Lookup_n-D';'Constant';'Relay';'Lookup2D';'Lookup';'Interval Test'};
block_h = gcbh;%2015a下版本可�?
block_type = get_param(block_h,'BlockType');
if strcmp(block_type,'SubSystem')
    invertvalH = get_param(block_h,'MaskType');
    if strcmp(invertvalH,'Interval Test')
        block_type = 'Interval Test';
    end
end
switch block_type
    case block_name{5,1}
        GUI.fh = figure('units','pixels',...
            'Color','w',...
            'menubar','none',...
            'ToolBar','auto',...
            'NumberTitle','on',...
            'IntegerHandle','off',...
            'Resize','on',...
            'name','Parameters Visualization Tool');
        table_out = get_param(block_h,'Table');
        break_in = get_param(block_h,'InputValues');
        
        %以下方法适用于非函数�?
        % plot_x = [break_in,'.Value'];
        % plot_y = [table_out,'.Value'];
        % p = plot(eval(plot_x),eval(plot_y));
        
        %以下方法适用于函数版
        x = evalin('base',break_in);
        y = evalin('base',table_out);
        if isobject(x)&&isobject(y)
            p = plot(x.Value,y.Value);
        else
            p = plot(x,y);
        end
        xlabel(strrep(break_in,'_','\_'));
        ylabel(strrep(table_out,'_','\_'));
        legend(strrep(table_out,'_','\_'),'Location','best');
        p.LineWidth = 2;
        p.Marker ='*';
        grid on;
    case block_name{1,1}
        GUI.fh = figure('units','pixels',...
            'Color','w',...
            'menubar','none',...
            'ToolBar','figure',...
            'NumberTitle','on',...
            'IntegerHandle','off',...
            'Resize','on',...
            'name','Parameters Visualization Tool');
        dim = get_param(block_h,'NumberOfTableDimensions');
        table_out = get_param(block_h,'Table');
        if dim == '1'
            break_in = get_param(block_h,'BreakpointsForDimension1');
            
            %以下方法适用于非函数�?
            % plot_x = [break_in,'.Value'];
            % plot_y = [table_out,'.Value'];
            % p = plot(eval(plot_x),eval(plot_y));
            
            %以下方法适用于函数版
            x = evalin('base',break_in);
            y = evalin('base',table_out);
            if isobject(x)&&isobject(y)
                p = plot(x.Value,y.Value);
            else
                p = plot(x,y);
            end
            xlabel(strrep(break_in,'_','\_'));
            ylabel(strrep(table_out,'_','\_'));
            legend(strrep(table_out,'_','\_'),'Location','best');
            p.LineWidth = 2;
            p.Marker ='*';
            grid on;
            %             hold on;
            %             f1 = figure;
            %             uit = uitable(f1)
            %             d = {'Male',52,true;'Male',40,true;'Female',25,false};
            %             uit.Data = d;
        else
            break_in1 = get_param(block_h,'BreakpointsForDimension1');
            break_in2 = get_param(block_h,'BreakpointsForDimension2');
            x = evalin('base',break_in2);
            y = evalin('base',break_in1);
            z = evalin('base',table_out);
            if isobject(x)&&isobject(y)&isobject(z)
                p = surf(x.Value,y.Value,z.Value);
                MaxV =max(max(z.Value));
                MinV = min(min(z.Value));
            else
                p = surf(x,y,z);
                MaxV =max(max(z));
                MinV = min(min(z));
            end
            %             err = floor(abs(MaxV-MinV));
            err = size(z);
            err = err(1,2);
            colorbar
            colormap(jet(10));%parula
            %     p = mesh(x.Value,y.Value,z.Value);
            x1 = xlabel(strrep(break_in2,'_','\_'));
            y1 = ylabel(strrep(break_in1,'_','\_'));
            zlabel(strrep(table_out,'_','\_'));
            set(x1,'Rotation',15);
            set(y1,'Rotation',-25);
            %  legend(strrep(table_out,'_','\_'),'Location','best');
            p.LineWidth = 2;
            p.Marker ='*';
            p.FaceColor = 'interp';
            grid on;
        end
    case block_name{4,1}
        GUI.fh = figure('units','pixels',...
            'Color','w',...
            'menubar','none',...
            'ToolBar','figure',...
            'NumberTitle','on',...
            'IntegerHandle','off',...
            'Resize','on',...
            'name','Parameters Visualization Tool');
        table_out = get_param(block_h,'Table');
        break_in1 = get_param(block_h,'RowIndex');
        break_in2 = get_param(block_h,'ColumnIndex');
        x = evalin('base',break_in2);
        y = evalin('base',break_in1);
        z = evalin('base',table_out);
        if isobject(x)&&isobject(y)&isobject(z)
            p = surf(x.Value,y.Value,z.Value);
            MaxV =max(max(z.Value));
            MinV = min(min(z.Value));
        else
            p = surf(x,y,z);
            MaxV =max(max(z));
            MinV = min(min(z));
        end
        %             err = floor(abs(MaxV-MinV));
        err = size(z);
        err = err(1,2);
        colorbar
        colormap(jet(10));%parula
        %     p = mesh(x.Value,y.Value,z.Value);
        x1 = xlabel(strrep(break_in2,'_','\_'));
        y1 = ylabel(strrep(break_in1,'_','\_'));
        zlabel(strrep(table_out,'_','\_'));
        set(x1,'Rotation',15);
        set(y1,'Rotation',-25);
        %  legend(strrep(table_out,'_','\_'),'Location','best');
        p.LineWidth = 2;
        p.Marker ='*';
        p.FaceColor = 'interp';
        grid on;
        
    case block_name{2,1}
        fprintf('---------------------------------------------\n');
        val = get_param(block_h,'Value');
        val_par = evalin('base',val);
        if isobject(val_par)
            par = val_par.Value;
            Dec = val_par.Description;
            Type = val_par.DataType;
            Min = val_par.Min;
            Max = val_par.Max;
            if strcmp(s_ver,ver_valid)
                Unit = val_par.DocUnits;
            else
                Unit = val_par.Unit;
            end
            %Comand Windows Dispaly
            fprintf('%s = %s\n',val,num2str(par));
            fprintf('Description:%s\n',Dec);
            fprintf('DataType:%s  Min:%s  Max:%s  Unit:%s\n',Type,num2str(Min),num2str(Max),Unit);
            %Help Diaglog
            h1 = helpdlg({[val,' = ',num2str(par)],...
                ['Description:',Dec],...
                ['DataType:',Type,'   Min:',num2str(Min),'   Max:',num2str(Max),'   Unit:',Unit]},val);
            %         strh1 = findobj(h1,'tag','MessageBox');
            strh1 = findobj(h1,'Type', 'text');
            set(strh1,'FontSize',10,'FontName','Calibri','Unit', 'normal');
            set(h1, 'Resize', 'on');
        else
            fprintf('%s = %s\n',val,num2str(val_par));
            h1 = helpdlg({[val,' = ',num2str(val_par)]},val);
            %             strh1 = findobj(h1,'tag','MessageBox');
            strh1 = findobj(h1,'Type', 'text');
            set(strh1,'FontSize',10,'FontName','Calibri','Unit', 'normal');
            set(h1, 'Resize', 'on');
        end
        
    case block_name{6,1}
        fprintf('---------------------------------------------\n');
        val = get_param(block_h,'uplimit');
        out_on = get_param(block_h,'IntervalClosedRight');
        val_par = evalin('base',val);
        par = val_par.Value;
        Dec = val_par.Description;
        Type = val_par.DataType;
        Min = val_par.Min;
        Max = val_par.Max;
        if strcmp(s_ver,ver_valid)
            Unit = val_par.DocUnits;
        else
            Unit = val_par.Unit;
        end
        fprintf('%s = %s;  Include Upper Value = %s\n',val,num2str(par),out_on);
        fprintf('Description:%s\n',Dec);
        fprintf('DataType:%s  Min:%s  Max:%s  Unit:%s\n',Type,num2str(Min),num2str(Max),Unit);
        
        fprintf('----------------------\n');
        val1 = get_param(block_h,'lowlimit');
        out_off = get_param(block_h,'IntervalClosedLeft');
        val_par1 = evalin('base',val1);
        par1 = val_par1.Value;
        Dec1 = val_par1.Description;
        Type1 = val_par1.DataType;
        Min1 = val_par1.Min;
        Max1 = val_par1.Max;
        if strcmp(s_ver,ver_valid)
            Unit1 = val_par1.DocUnits;
        else
            Unit1 = val_par1.Unit;
        end
        %Comd windows disp
        fprintf('%s = %s;  Include Lower Value = %s\n',val1,num2str(par1),out_off);
        fprintf('Description:%s\n',Dec1);
        fprintf('DataType:%s  Min:%s  Max:%s  Unit:%s\n',Type1,num2str(Min1),num2str(Max1),Unit1);
        %Help Dialog
        h2 = helpdlg({[val,' = ',num2str(par),';  ','Include Upper Value = ',out_on],...
            ['Description:',Dec],...
            ['DataType:',Type,' Min:',num2str(Min),' Max:',num2str(Max),' Unit:',Unit],...
            '------------------------',...
            [val1,' = ',num2str(par1),';  ','Include Lower Value = ',out_off],...
            ['Description:',Dec1],...
            ['DataType:',Type1,' Min:',num2str(Min1),' Max:',num2str(Max1),' Unit:',Unit1]},'Realy');
        strh2 = findobj(h2,'Type', 'text');
        set(strh2,'FontSize',10,'FontName','Calibri','Unit', 'normal');
        set(h2, 'Resize', 'on');
    case block_name{3,1}
        fprintf('---------------------------------------------\n');
        val = get_param(block_h,'OnSwitchValue');
        out_on = get_param(block_h,'OnOutputValue');
        val_par = evalin('base',val);
        par = val_par.Value;
        Dec = val_par.Description;
        Type = val_par.DataType;
        Min = val_par.Min;
        Max = val_par.Max;
        if strcmp(s_ver,ver_valid)
            Unit = val_par.DocUnits;
        else
            Unit = val_par.Unit;
        end
        fprintf('%s = %s;  Output when on = %s\n',val,num2str(par),out_on);
        fprintf('Description:%s\n',Dec);
        fprintf('DataType:%s  Min:%s  Max:%s  Unit:%s\n',Type,num2str(Min),num2str(Max),Unit);
        
        fprintf('----------------------\n');
        val1 = get_param(block_h,'OffSwitchValue');
        out_off = get_param(block_h,'OffOutputValue');
        val_par1 = evalin('base',val1);
        par1 = val_par1.Value;
        Dec1 = val_par1.Description;
        Type1 = val_par1.DataType;
        Min1 = val_par1.Min;
        Max1 = val_par1.Max;
        if strcmp(s_ver,ver_valid)
            Unit1 = val_par1.DocUnits;
        else
            Unit1 = val_par1.Unit;
        end
        %Comd windows disp
        fprintf('%s = %s;  Output when off = %s\n',val1,num2str(par1),out_off);
        fprintf('Description:%s\n',Dec1);
        fprintf('DataType:%s  Min:%s  Max:%s  Unit:%s\n',Type1,num2str(Min1),num2str(Max1),Unit1);
        %Help Dialog
        h2 = helpdlg({[val,' = ',num2str(par),';  ','Output when on = ',out_on],...
            ['Description:',Dec],...
            ['DataType:',Type,' Min:',num2str(Min),' Max:',num2str(Max),' Unit:',Unit],...
            '------------------------',...
            [val1,' = ',num2str(par1),';  ','Output when off = ',out_off],...
            ['Description:',Dec1],...
            ['DataType:',Type1,' Min:',num2str(Min1),' Max:',num2str(Max1),' Unit:',Unit1]},'Realy');
        strh2 = findobj(h2,'Type', 'text');
        set(strh2,'FontSize',10,'FontName','Calibri','Unit', 'normal');
        set(h2, 'Resize', 'on');
    otherwise
        opts = struct('WindowStyle','modal',...
            'Interpreter','tex');
        warndlg('\color{blue} Please Click The Correct Block!',...
            'CalDisp Warning', opts);
end
end
function easymodel(callbackInfo)
run('EasyModel.mlapp');
end
function myCallback1(callbackInfo)
To_Excel;
end
function myCallback2(callbackInfo)
Gen_Signals;
end

function schema = EditTC(callbackInfo)
schema = sl_action_schema;
schema.label = 'Edit TC';
schema.userdata = '';
schema.callback = @EditTestCase;
end
function EditTestCase(callbackInfo)
current_path = cd;
str_id = strfind(current_path,'\');
test_name = current_path(str_id(end)+1:end);
mil_path = evalin('base','mil_path');
Test_Path = [mil_path '\units_mil' '\' test_name];
slx_path = gencase(gcs,Test_Path,current_path);
[file,path] = uigetfile('*.xlsx');
if isequal(file,0)
    disp('User selected Cancel');
else
    disp(['User selected ', fullfile(path,file)]);
    %addpath(path);
    winopen(fullfile(path,file));
end
%cd(current_path);
end

function schema = UnitTest(callbackInfo)
schema = sl_action_schema;
schema.label = 'Unit Test';
schema.userdata = '';
schema.callback = @UnitTestFcn;
end
function UnitTestFcn(callbackInfo)
getexcel;
end

function schema = UpdateTC(callbackInfo)
schema = sl_action_schema;
schema.label = 'Update TC';
schema.userdata = '';
schema.callback = @UpdateTestCase;
end
function UpdateTestCase(callbackInfo)
updatecase;
end

% function sl_customization(cm)
%
%   %% Register custom menu function.
%   cm.addCustomMenuFcn('Simulink:ToolsMenu', @getMyMenuItems);
% end
%
% %% Define the custom menu function.
% function schemaFcns = getMyMenuItems(callbackInfo)
%   schemaFcns = {@getItem1, ...
%                @getItem2, ...
%                {@getItem3,3}, ... %% Pass 3 as user data to getItem3.
%                @getItem4};
% end
%
% %% Define the schema function for first menu item.
% function schema = getItem1(callbackInfo)
%   schema = sl_action_schema;
%   schema.label = 'Item One';
%   schema.userdata = 'item one';
%   schema.callback = @myCallback1;
% end
%
% function myCallback1(callbackInfo)
%   disp(['Callback for item ' callbackInfo.userdata ' was called']);
% end
%
% function schema = getItem2(callbackInfo)
%   % Make a submenu label 'Item Two' with
%   % the menu item above three times.
%   schema = sl_container_schema;
%   schema.label = 'Item Two';
% 	schema.childrenFcns = {@getItem1, @getItem1, @getItem1};
% end
%
% function schema = getItem3(callbackInfo)
%   % Create a menu item whose label is
%   % 'Item Three: 3', with the 3 being passed
%   % from getMyItems above.
%
%   schema = sl_action_schema;
%   schema.label = ['Item Three: ' num2str(callbackInfo.userdata)];
% end
%
% function myToggleCallback(callbackInfo)
%     if strcmp(get_param(gcs, 'ScreenColor'), 'red') == 0
%         set_param(gcs, 'ScreenColor', 'red');
%     else
%         set_param(gcs, 'ScreenColor', 'white');
%     end
% end
%
% %% Define the schema function for a toggle menu item.
% function schema = getItem4(callbackInfo)
%   schema = sl_toggle_schema;
%   schema.label = 'Red Screen';
%   if strcmp(get_param(gcs, 'ScreenColor'), 'red') == 1
%     schema.checked = 'checked';
%   else
%     schema.checked = 'unchecked';
%   end
%   schema.callback = @myToggleCallback;
% end
