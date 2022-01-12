function AT_gen_cal(names,author)
%Auto Generator Constants Paramter of FEIDI VCU
%Creat By：QingYa.Du
names = names;
tab_strId = strfind(names,'/');
if ~isempty(tab_strId)
    cal_name = names(tab_strId(1,end)+1:end);
else
    cal_name = names;
end
authors = author;
outfile = [cal_name,'_cal.m'];
fileID = fopen(outfile,'w');
title = [cal_name,'_cal.m ',date, ' By:',authors];
fprintf(fileID,['%%',title,'\n']);
fprintf(fileID,'disp(''%s'');\n',title);
fprintf(fileID,'%%-------------------------------------------------------------------------------\n');
fprintf(fileID,'%%Calibration definitions for this feature;\n');
fprintf(fileID,'%%Use: a2l_cal(name, default value, units, min, max, data-type, description)\n');
fprintf(fileID,'%%-------------------------------------------------------------------------------\n');
fprintf(fileID,'\n');
fprintf(fileID,'%%%% Constants\n');
[Con_Names] = get_cal_names(names);

if ~isempty(Con_Names)
    for i = 1:length(Con_Names)
        if i == 80
            disp('Debug');
            pause(5);
        end
        if ~isempty(Con_Names{i,1})
            str = ['a2l_cal(''',Con_Names{i,1}{1,1} ''',', '  ',Con_Names{i,1}{1,2},',','  ','''',Con_Names{i,1}{1,3},'''',...
                ',','  ',Con_Names{i,1}{1,4},',','  ',Con_Names{i,1}{1,5},',  ','''',Con_Names{i,1}{1,6},'''',',  ','''',Con_Names{i,1}{1,7},'''',')'];
            fprintf(fileID,[str,';\n']);
        end
    end
end


fclose(fileID);
end
%% get_cal_names函数
function [Con_Values_Valid] = get_cal_names(names)
global key_str
key_str = {
    'u',0,'V' ,0,5,'single','Override value for signal ';
    'i',0,'A' ,0,300,'single','Override value for signal ';
    'b',0,'flg',0,1,'boolean','Override value for signal';
    't',0,'C',-50,100,'single','Override value for signal ';
    'tq',0,'Nm',0,100,'single','Override value for signal ';
    'pwr',0,'Kw',0,100,'single','Override value for signal ';
    'p',0,' ',0,100,'uint16','Override value for signal ';
    'n',0,'rpm',0,9500,'single','Override value for signal ';
    'pt',0,'%',0,100,'single','Override value for signal ';
    'kph',0,'km/h',0,200,'single','Override value for signal ';
    'kp',0,'',0,100,'single','Override value for signal ';
    'km',0,'km',0,500,'single','Override value for signal ';
    'q',0,'kwPh',0,50,'single','Override value for signal ';
    'flg',0,'flg',0,1,'boolean','Override value for signal ';
    'e',0,'enum',0,255,'uint8 ','Override flag for signal ';
    };
%获取模型中的Constant、LookUp标定量名称；
%[Cosntat,1-DLookUp,2-DLookUp] = get_cal_names(顶层模型名称)；
%% 获取Constant标定量
cons =  find_system(names,'FindAll','on','BlockType','Constant');
if isempty(cons)
    Con_Values_Valid = {};
else
    Con_Values = get_param(cons,'Value');
    Con_Values_Reg = regexp(Con_Values, '([a-z]+)c_.*','names');
    j =1;
    count = 0;
    for i = 1:length(Con_Values)
        count = count+1;
        if ~isempty(Con_Values_Reg{i,1})
            Con_Values_name = Con_Values{i,1};
            count = count+1;
            %-----------------------------------------------------------
            sym_Id = strfind(Con_Values{i,1},'_');
            last_str = Con_Values{i,1}(sym_Id(1)+1:sym_Id(2)-1); %获取信号类型
            Ids = strcmpi(last_str,key_str(:,1));%最后一个关键字查询
            verify_Id = find(Ids);%最后一个关键字ID确认
            dispname = Con_Values{i,1}(sym_Id(2)+1:end);
            %             first_str = Con_Values{i,1}(sym_Id(1)+1:sym_Id(2)-1); %获取信号属性
            %             first_str_Id = strcmpi(first_str,key_str(:,1));%信号属性查询
            %             verify_first_strId = find(first_str_Id);%信号属性ID确认
            if ~isempty(verify_Id)
                Con_Values_value = num2str(key_str{verify_Id,2});
                Con_Values_unit = key_str{verify_Id,3};
                Con_Values_min = num2str(key_str{verify_Id,4});
                Con_Values_max = num2str(key_str{verify_Id,5});
                Con_Values_type = key_str{verify_Id,6};
                Con_Values_dec = [key_str{verify_Id,7},dispname];
                Con_Values_Valid{j,1} = {Con_Values_name,Con_Values_value,Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
                %             else  if isempty(verify_Id)&&~isempty(verify_first_strId)
                %                     Con_Values_value = num2str(key_str{verify_first_strId,2});
                %                     Con_Values_unit = key_str{verify_first_strId,3};
                %                     Con_Values_min = num2str(key_str{verify_first_strId,4});
                %                     Con_Values_max = num2str(key_str{verify_first_strId,5});
                %                     Con_Values_type = key_str{verify_first_strId,6};
                %                     Con_Values_dec = key_str{verify_first_strId,7};
                %                     Con_Values_Valid{j,1} = {Con_Values_name,Con_Values_value,Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
                %                 else
                %                     Con_Values_Valid{j,1} = {Con_Values_name,'0','Dft','0','1','single',' '};
                %                 end
            end
            j = j+1;
            
            %-----------------------------------------------------------
            
            %             if count == 260
            %                 disp('Debug');
            %                 pause(5);
            %             end
        end
    end
    disp(['RegNum:',num2str(length(Con_Values_Reg)),'Constants Num:   ',num2str(count),';   ','Gen_Con_Num:   ',num2str(length(Con_Values_Valid))]);
    count=0;
    j =1;
    jj =1;
    jjj = 1;
    jjjj =1;
    jjjjj = 1;
    nn=1;
    nnn = 1;
    %     %% 获取Lookup标定量
    %     lookups =  find_system(names,'FindAll','on','BlockType','Lookup_n-D');
    %     if isempty(lookups)
    %         LookUp_1Dims ={};
    %         LookUp_2Dims = {};
    %         Comm_Info_2D = {};
    %         Comm_Info_2D_X = {};
    %         Comm_Info_2D_Y = {};
    %     else
    %         Lookup_Dim = get_param(lookups,'NumberOfTableDimensions');
    %         n = 1;
    %         m = 1;
    %         for i = 1:length(Lookup_Dim)
    %             if Lookup_Dim{i,1}=='2'
    %                 hands = lookups(i,1);
    %                 %-----------------------------------------------------------
    %                 LookUp_2Dim_Tables= get_param(hands,'Table');
    %                 %-----------------------------------------------------------
    %                 sym_Id = strfind(LookUp_2Dim_Tables,'_');
    %                 last_str = LookUp_2Dim_Tables(sym_Id(end)+1:end); %获取最后一个关键字
    %                 Ids = strcmpi(last_str,key_str(:,1));%最后一个关键字查询
    %                 verify_Id = find(Ids);%最后一个关键字ID确认
    %                 first_str = LookUp_2Dim_Tables(sym_Id(1)+1:sym_Id(2)-1); %获取信号属性
    %                 first_str_Id = strcmpi(first_str,key_str(:,1));%信号属性查询
    %                 verify_first_strId = find(first_str_Id);%信号属性ID确认
    %                 if ~isempty(verify_Id)
    % %                     Con_Values_value = num2str(key_str{verify_Id,2});
    %                     Con_Values_unit = key_str{verify_Id,3};
    %                     Con_Values_min = num2str(key_str{verify_Id,4});
    %                     Con_Values_max = num2str(key_str{verify_Id,5});
    %                     Con_Values_type = key_str{verify_Id,6};
    %                     Con_Values_dec = key_str{verify_Id,7};
    %                     Comm_Info_2D{j,1} = {LookUp_2Dim_Tables,'[0 0 0;0.5 0.5 0.5;1 1 1]',Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
    %                 else  if isempty(verify_Id)&&~isempty(verify_first_strId)
    %                         Con_Values_value = num2str(key_str{verify_first_strId,2});
    %                         Con_Values_unit = key_str{verify_first_strId,3};
    %                         Con_Values_min = num2str(key_str{verify_first_strId,4});
    %                         Con_Values_max = num2str(key_str{verify_first_strId,5});
    %                         Con_Values_type = key_str{verify_first_strId,6};
    %                         Con_Values_dec = key_str{verify_first_strId,7};
    %                         Comm_Info_2D{j,1} = {LookUp_2Dim_Tables,'[0 0 0;0.5 0.5 0.5;1 1 1]',Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
    %                     else
    %                         Comm_Info_2D{j,1} = {LookUp_2Dim_Tables,'[[0 0 0;0.5 0.5 0.5;1 1 1]','Dft','0','1','single',' '};
    %                     end
    %                 end
    %                 j = j+1;
    %                 %-----------------------------------------------------------------------
    %                 LookUp_2Dim_BreakPoints1= get_param(hands,'BreakpointsForDimension1');
    %                 %-----------------------------------------------------------
    %                 sym_Id = strfind(LookUp_2Dim_BreakPoints1,'_');
    %                 last_str = LookUp_2Dim_BreakPoints1(sym_Id(end)+1:end); %获取最后一个关键字
    %                 Ids = strcmpi(last_str,key_str(:,1));%最后一个关键字查询
    %                 verify_Id = find(Ids);%最后一个关键字ID确认
    %                 first_str = LookUp_2Dim_BreakPoints1(sym_Id(1)+1:sym_Id(2)-1); %获取信号属性
    %                 first_str_Id = strcmpi(first_str,key_str(:,1));%信号属性查询
    %                 verify_first_strId = find(first_str_Id);%信号属性ID确认
    %                 if ~isempty(verify_Id)
    %                     Con_Values_value = num2str(key_str{verify_Id,2});
    %                     Con_Values_unit = key_str{verify_Id,3};
    %                     Con_Values_min = num2str(key_str{verify_Id,4});
    %                     Con_Values_max = num2str(key_str{verify_Id,5});
    %                     Con_Values_type = key_str{verify_Id,6};
    %                     Con_Values_dec = key_str{verify_Id,7};
    %                     Comm_Info_2D_X{jj,1} = {LookUp_2Dim_BreakPoints1,'[0 0.5 1]',Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
    %                 else  if isempty(verify_Id)&&~isempty(verify_first_strId)
    %                         Con_Values_value = num2str(key_str{verify_first_strId,2});
    %                         Con_Values_unit = key_str{verify_first_strId,3};
    %                         Con_Values_min = num2str(key_str{verify_first_strId,4});
    %                         Con_Values_max = num2str(key_str{verify_first_strId,5});
    %                         Con_Values_type = key_str{verify_first_strId,6};
    %                         Con_Values_dec = key_str{verify_first_strId,7};
    %                         Comm_Info_2D_X{jj,1} = {LookUp_2Dim_BreakPoints1,'[0 0.5 1]',Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
    %                     else
    %                         Comm_Info_2D_X{jj,1} = {LookUp_2Dim_BreakPoints1,'[0 0.5 1]','Dft','0','1','single',' '};
    %                     end
    %                 end
    %                 jj = jj+1;
    %                 %-----------------------------------------------------------------------
    %                 LookUp_2Dim_BreakPoints2 = get_param(hands,'BreakpointsForDimension2');
    %                 %                 count = count+1;
    %                 %                 [Propertys1] = Comm(LookUp_2Dim_BreakPoints2,count);
    %                 %-----------------------------------------------------------
    %                 sym_Id = strfind(LookUp_2Dim_BreakPoints2,'_');
    %                 last_str = LookUp_2Dim_BreakPoints2(sym_Id(end)+1:end); %获取最后一个关键字
    %                 Ids = strcmpi(last_str,key_str(:,1));%最后一个关键字查询
    %                 verify_Id = find(Ids);%最后一个关键字ID确认
    %                 first_str = LookUp_2Dim_BreakPoints2(sym_Id(1)+1:sym_Id(2)-1); %获取信号属性
    %                 first_str_Id = strcmpi(first_str,key_str(:,1));%信号属性查询
    %                 verify_first_strId = find(first_str_Id);%信号属性ID确认
    %                 if ~isempty(verify_Id)
    %                     Con_Values_value = num2str(key_str{verify_Id,2});
    %                     Con_Values_unit = key_str{verify_Id,3};
    %                     Con_Values_min = num2str(key_str{verify_Id,4});
    %                     Con_Values_max = num2str(key_str{verify_Id,5});
    %                     Con_Values_type = key_str{verify_Id,6};
    %                     Con_Values_dec = key_str{verify_Id,7};
    %                     Comm_Info_2D_Y{jjj,1} = {LookUp_2Dim_BreakPoints2,'[0 0.5 1]',Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
    %                 else  if isempty(verify_Id)&&~isempty(verify_first_strId)
    %                         Con_Values_value = num2str(key_str{verify_first_strId,2});
    %                         Con_Values_unit = key_str{verify_first_strId,3};
    %                         Con_Values_min = num2str(key_str{verify_first_strId,4});
    %                         Con_Values_max = num2str(key_str{verify_first_strId,5});
    %                         Con_Values_type = key_str{verify_first_strId,6};
    %                         Con_Values_dec = key_str{verify_first_strId,7};
    %                         Comm_Info_2D_Y{jjj,1} = {LookUp_2Dim_BreakPoints2,'[0 0.5 1]',Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
    %                     else
    %                         Comm_Info_2D_Y{jjj,1} = {LookUp_2Dim_BreakPoints2,'[0 0.5 1]','Dft','0','1','single',' '};
    %                     end
    %                 end
    %                 jjj = jjj+1;
    %                 %-----------------------------------------------------------------------
    %                 LookUp_2Dims{n,1} = {LookUp_2Dim_Tables,LookUp_2Dim_BreakPoints1,LookUp_2Dim_BreakPoints2};
    %                 n = n+1;
    %             else %1-DLookup
    %                 hands = lookups(i,1);
    %                 LookUp_1Dim_Tables= get_param(hands,'Table');
    %                 %-----------------------------------------------------------
    %                 sym_Id = strfind(LookUp_1Dim_Tables,'_');
    %                 last_str = LookUp_1Dim_Tables(sym_Id(end)+1:end); %获取最后一个关键字
    %                 Ids = strcmpi(last_str,key_str(:,1));%最后一个关键字查询
    %                 verify_Id = find(Ids);%最后一个关键字ID确认
    %                 first_str = LookUp_1Dim_Tables(sym_Id(1)+1:sym_Id(2)-1); %获取信号属性
    %                 first_str_Id = strcmpi(first_str,key_str(:,1));%信号属性查询
    %                 verify_first_strId = find(first_str_Id);%信号属性ID确认
    %                 if ~isempty(verify_Id)
    %                     Con_Values_value = num2str(key_str{verify_Id,2});
    %                     Con_Values_unit = key_str{verify_Id,3};
    %                     Con_Values_min = num2str(key_str{verify_Id,4});
    %                     Con_Values_max = num2str(key_str{verify_Id,5});
    %                     Con_Values_type = key_str{verify_Id,6};
    %                     Con_Values_dec = key_str{verify_Id,7};
    %                     Comm_Info_1D_Out{nn,1} = {LookUp_1Dim_Tables,'[0 0.5 1]',Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
    %                 else  if isempty(verify_Id)&&~isempty(verify_first_strId)
    %                         Con_Values_value = num2str(key_str{verify_first_strId,2});
    %                         Con_Values_unit = key_str{verify_first_strId,3};
    %                         Con_Values_min = num2str(key_str{verify_first_strId,4});
    %                         Con_Values_max = num2str(key_str{verify_first_strId,5});
    %                         Con_Values_type = key_str{verify_first_strId,6};
    %                         Con_Values_dec = key_str{verify_first_strId,7};
    %                         Comm_Info_1D_Out{nn,1} = {LookUp_1Dim_Tables,'[0 0.5 1]',Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
    %                     else
    %                         Comm_Info_1D_Out{nn,1} = {LookUp_1Dim_Tables,'[0 0.5 1]','Dft','0','1','single',' '};
    %                     end
    %                 end
    %                 nn = nn+1;
    %                 %-----------------------------------------------------------------------
    %                 LookUp_1Dim_BreakPoints1= get_param(hands,'BreakpointsForDimension1');
    %                 %-----------------------------------------------------------
    %                 sym_Id = strfind(LookUp_1Dim_BreakPoints1,'_');
    %                 last_str = LookUp_1Dim_BreakPoints1(sym_Id(end)+1:end); %获取最后一个关键字
    %                 Ids = strcmpi(last_str,key_str(:,1));%最后一个关键字查询
    %                 verify_Id = find(Ids);%最后一个关键字ID确认
    %                 first_str = LookUp_1Dim_BreakPoints1(sym_Id(1)+1:sym_Id(2)-1); %获取信号属性
    %                 first_str_Id = strcmpi(first_str,key_str(:,1));%信号属性查询
    %                 verify_first_strId = find(first_str_Id);%信号属性ID确认
    %                 if ~isempty(verify_Id)
    %                     Con_Values_value = num2str(key_str{verify_Id,2});
    %                     Con_Values_unit = key_str{verify_Id,3};
    %                     Con_Values_min = num2str(key_str{verify_Id,4});
    %                     Con_Values_max = num2str(key_str{verify_Id,5});
    %                     Con_Values_type = key_str{verify_Id,6};
    %                     Con_Values_dec = key_str{verify_Id,7};
    %                     Comm_Info_1D_In{nnn,1} = {LookUp_1Dim_BreakPoints1,'[0 0.5 1]',Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
    %                 else  if isempty(verify_Id)&&~isempty(verify_first_strId)
    %                         Con_Values_value = num2str(key_str{verify_first_strId,2});
    %                         Con_Values_unit = key_str{verify_first_strId,3};
    %                         Con_Values_min = num2str(key_str{verify_first_strId,4});
    %                         Con_Values_max = num2str(key_str{verify_first_strId,5});
    %                         Con_Values_type = key_str{verify_first_strId,6};
    %                         Con_Values_dec = key_str{verify_first_strId,7};
    %                         Comm_Info_1D_In{nnn,1} = {LookUp_1Dim_BreakPoints1,'[0 0.5 1]',Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
    %                     else
    %                         Comm_Info_1D_In{nnn,1} = {LookUp_1Dim_BreakPoints1,'[0 0.5 1]','Dft','0','1','single',' '};
    %                     end
    %                 end
    %                 nnn = nnn+1;
    %                 %-----------------------------------------------------------------------
    %                 LookUp_1Dims{m,1} = {LookUp_1Dim_Tables,LookUp_1Dim_BreakPoints1};
    %                 m = m+1;
    %             end
    %         end
    %     end
    %     %     disp(['Constants Num:   ',num2str(count),';','Gen_Con_Num:   ',num2str(length(Con_Values_Valid))]);
    %     disp(['1-D MapNum:       ',num2str(length(LookUp_1Dims)),';','    2-D MapNum:       ',num2str(length(LookUp_2Dims))]);
    %     %% 获取Relay标定量
    %     relays =  find_system('Copy_of_VCU_Integration_EMO_NewArch/VCU/VIL__VCU_Input_Layer','FindAll','on','BlockType','Relay');
    %     if isempty(relays)
    %         Relay_Values= {};
    %         Comm_Info_RelyOn = {};
    %         Comm_Info_RelyOff ={};
    %     else
    %         k =1;
    %         for i = 1:length(relays)
    %             Relay_Values_On = get_param(relays(i,1),'OnSwitchValue');
    %             %-----------------------------------------------------------
    %             sym_Id = strfind(Relay_Values_On,'_');
    %             last_str = Relay_Values_On(sym_Id(end)+1:end); %获取最后一个关键字
    %             Ids = strcmpi(last_str,key_str(:,1));%最后一个关键字查询
    %             verify_Id = find(Ids);%最后一个关键字ID确认
    %             first_str = Relay_Values_On(sym_Id(1)+1:sym_Id(2)-1); %获取信号属性
    %             first_str_Id = strcmpi(first_str,key_str(:,1));%信号属性查询
    %             verify_first_strId = find(first_str_Id);%信号属性ID确认
    %             if ~isempty(verify_Id)
    %                 Con_Values_value = num2str(key_str{verify_Id,2});
    %                 Con_Values_unit = key_str{verify_Id,3};
    %                 Con_Values_min = num2str(key_str{verify_Id,4});
    %                 Con_Values_max = num2str(key_str{verify_Id,5});
    %                 Con_Values_type = key_str{verify_Id,6};
    %                 Con_Values_dec = key_str{verify_Id,7};
    %                 Comm_Info_RelyOn{jjjj,1} = {Relay_Values_On,Con_Values_value,Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
    %             else  if isempty(verify_Id)&&~isempty(verify_first_strId)
    %                     Con_Values_value = num2str(key_str{verify_first_strId,2});
    %                     Con_Values_unit = key_str{verify_first_strId,3};
    %                     Con_Values_min = num2str(key_str{verify_first_strId,4});
    %                     Con_Values_max = num2str(key_str{verify_first_strId,5});
    %                     Con_Values_type = key_str{verify_first_strId,6};
    %                     Con_Values_dec = key_str{verify_first_strId,7};
    %                     Comm_Info_RelyOn{jjjj,1} = {Relay_Values_On,Con_Values_value,Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
    %                 else
    %                     Comm_Info_RelyOn{jjjj,1} = {Relay_Values_On,'0','Dft','0','1','single',' '};
    %                 end
    %             end
    %             jjjj = jjjj+1;
    %             %-----------------------------------------------------------------------
    %             Relay_Values_Off = get_param(relays(i,1),'OffSwitchValue');
    %             %-----------------------------------------------------------
    %             sym_Id = strfind(Relay_Values_Off,'_');
    %             last_str = Relay_Values_Off(sym_Id(end)+1:end); %获取最后一个关键字
    %             Ids = strcmpi(last_str,key_str(:,1));%最后一个关键字查询
    %             verify_Id = find(Ids);%最后一个关键字ID确认
    %             first_str = Relay_Values_Off(sym_Id(1)+1:sym_Id(2)-1); %获取信号属性
    %             first_str_Id = strcmpi(first_str,key_str(:,1));%信号属性查询
    %             verify_first_strId = find(first_str_Id);%信号属性ID确认
    %             if ~isempty(verify_Id)
    %                 Con_Values_value = num2str(key_str{verify_Id,2});
    %                 Con_Values_unit = key_str{verify_Id,3};
    %                 Con_Values_min = num2str(key_str{verify_Id,4});
    %                 Con_Values_max = num2str(key_str{verify_Id,5});
    %                 Con_Values_type = key_str{verify_Id,6};
    %                 Con_Values_dec = key_str{verify_Id,7};
    %                 Comm_Info_RelyOff{jjjjj,1} = {Relay_Values_Off,Con_Values_value,Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
    %             else  if isempty(verify_Id)&&~isempty(verify_first_strId)
    %                     Con_Values_value = num2str(key_str{verify_first_strId,2});
    %                     Con_Values_unit = key_str{verify_first_strId,3};
    %                     Con_Values_min = num2str(key_str{verify_first_strId,4});
    %                     Con_Values_max = num2str(key_str{verify_first_strId,5});
    %                     Con_Values_type = key_str{verify_first_strId,6};
    %                     Con_Values_dec = key_str{verify_first_strId,7};
    %                     Comm_Info_RelyOff{jjjjj,1} = {Relay_Values_Off,Con_Values_value,Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
    %                 else
    %                     Comm_Info_RelyOff{jjjjj,1} = {Relay_Values_Off,'0','Dft','0','1','single',' '};
    %                 end
    %             end
    %             jjjjj = jjjjj+1;
    %             %-----------------------------------------------------------------------
    %
    %             Relay_Values{k,1} = {Relay_Values_On,Relay_Values_Off};
    %             k = k+1;
    %         end
    %     end
    %     %         disp(['Constants Num:   ',num2str(count),';   ','Gen_Con_Num:   ',num2str(length(Con_Values_Valid))]);
    %     disp(['Relay Num:            ',num2str(length(Relay_Values))]);
    % end
end
%     function [Propertys] = Comm(names,rolls)
%         global key_str
%         sym_Id = strfind(names,'_');
%         last_str = names(sym_Id(end)+1:end); %获取最后一个关键字
%         Ids = strcmpi(last_str,key_str(:,1));%最后一个关键字查询
%         verify_Id = find(Ids);%最后一个关键字ID确认
%         first_str = names(sym_Id(1)+1:sym_Id(2)-1); %获取信号属性
%         first_str_Id = strcmp(first_str,key_str(:,1));%信号属性查询
%         verify_first_strId = find(first_str_Id);%信号属性ID确认
%         if ~isempty(verify_Id)
%             Con_Values_value = num2str(key_str{verify_Id,2});
%             Con_Values_unit = key_str{verify_Id,3};
%             Con_Values_min = num2str(key_str{verify_Id,4});
%             Con_Values_max = num2str(key_str{verify_Id,5});
%             Con_Values_type = key_str{verify_Id,6};
%             Con_Values_dec = key_str{verify_Id,7};
%             Propertys{rolls,1} = {names,Con_Values_value,Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
%         else  if isempty(verify_Id)&&~isempty(verify_first_strId)
%                 Con_Values_value = num2str(key_str{verify_first_strId,2});
%                 Con_Values_unit = key_str{verify_first_strId,3};
%                 Con_Values_min = num2str(key_str{verify_first_strId,4});
%                 Con_Values_max = num2str(key_str{verify_first_strId,5});
%                 Con_Values_type = key_str{verify_first_strId,6};
%                 Con_Values_dec = key_str{verify_first_strId,7};
%                 Propertys{rolls,1} = {names,Con_Values_value,Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
%             else
%                 Propertys{rolls,1} = {LookUp_2Dim_BreakPoints2,'[0 0 0]','Dft','0','1','single',' '};
%             end
%         end
end