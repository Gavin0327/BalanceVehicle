function [Con_Values_Valid] = AT_get_cal_names(names)
global key_str 
    %-----------------------------����궨��vilc_xx_:xx
    %u-��ѹ��i-������b-����ֵ��t-�¶ȣ�tq-Ť�أ�pwr-���ʣ�p-PWM��q-������SOC��n-ת�٣�kph-���٣�pt-���ȣ�kp-kpa��ѹ��km-��̣�kwph-Ч��;flg-ʹ������
key_str = { %�ؼ��֣�Ĭ��ֵ����λ����Сֵ�����ֵ���ź����ͣ�����
    'u',0,'v' ,0,5,'single','Override value for signal ';
    'b',0,'flg',0,1,'boolean','';
    't',0,'C',-50,100,'single',' ';
    'tq',0,'Nm',0,100,'single',' ';
    'pwr',0,'Kw',0,100,'single',' ';
    'p',0,' ',0,100,'uint16',' ';
    'n',0,'rpm',0,9500,'single',' ';
    'pt',0,'%',0,100,'single',' ';
    'kph',0,'km/h',0,200,'single',' ';
    'kp',0,'',0,100,'single',' ';
    'km',0,'km',0,500,'single',' ';
    'q',0,'kwPh',0,50,'single',' ';
    'flg',0,'flg',0,1,'boolean: ',' ';
    'e',0,'enum',0,255,'uint8 ',' ';
    };
% key_str = {
%     's',0,'s' ,0,10,'single',' ';
%     'Nm',0,'Nm',0,100,'single',' ';
%     'Flg',0,'flg',0,1,'boolean',' ';
%     'b',0,'flg',0,1,'boolean',' ';
%     'Nmps',0,'Nm/s',0,100,'single',' ';
%     'pct',0,'%',0,100,'single',' ';
%     'rpm',0,'rpm',0,50,'single',' ';
%     'rpmps',0,'rpm/s',0,50,'single',' ';
%     'kW',0,'kW',0,5,'single',' ';
%     'fact',0,'',-1,1,'single',' ';
%     'f',0,'',-1,1,'single',' ';
%     'kph',0,'km/h',0,50,'single',' ';
%     'C',0,'C',0,50,'single',' ';
%     'e',0,'enum',[],[],'Enum: ',' ';
%     'kPa',0,'kPa',0,100,'single',' ';
%     'bar',0,'bar',0,5,'single',' ';
%     'v',0,'v',0,5,'single',' ';
%     'p',0,'kpa',0,5,'single',' ';
%     'kmph',0,'km/h',0,50,'single',' ';
%     };
%��ȡģ���е�Constant��LookUp�궨�����ƣ�
%[Cosntat,1-DLookUp,2-DLookUp] = get_cal_names(����ģ������)��
%% ��ȡConstant�궨��
constants =  find_system(names,'FindAll','on','BlockType','Constant');
if isempty(constants)
    Con_Values_Valid = {};
else
    Con_Values = get_param(constants,'Value');
    Con_Values_Reg = regexp(Con_Values, '([a-z]+)_c.*','names');
    j =1;
    count = 0;
    for i = 1:length(Con_Values)
        %         count = count+1;
        %         if  count == 22
        %             disp('DebugUse');
        %             pause(3);
        %         end
        if ~isempty(Con_Values_Reg{i,1})
            Con_Values_name = Con_Values{i,1};
            %-----------------------------------------------------------
            sym_Id = strfind(Con_Values{i,1},'_');
            last_str = Con_Values{i,1}(sym_Id(1):sym_Id(2)-1); %��ȡ�źŹؼ���
            Ids = strcmpi(last_str,key_str(:,1));%�ؼ�����key_str�е�λ�ò�ѯ
            verify_Id = find(Ids);%�ؼ���λ��ȷ��
            first_str = Con_Values{i,1}(sym_Id(1)+1:sym_Id(2)-1); %��ȡ�ź�����
            first_str_Id = strcmpi(first_str,key_str(:,1));%�ź����Բ�ѯ
            verify_first_strId = find(first_str_Id);%�ź�����IDȷ��
            if ~isempty(verify_Id)
                Con_Values_value = num2str(key_str{verify_Id,2});
                Con_Values_unit = key_str{verify_Id,3};
                Con_Values_min = num2str(key_str{verify_Id,4});
                Con_Values_max = num2str(key_str{verify_Id,5});
                Con_Values_type = key_str{verify_Id,6};
                Con_Values_dec = key_str{verify_Id,7};
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
            count = count+1;
        end
    end
    disp(['Constants Num:   ',num2str(count),';   ','Gen_Con_Num:   ',num2str(length(Con_Values_Valid))]);
    count=0;
    j =1;
    jj =1;
    jjj = 1;
    jjjj =1;
    jjjjj = 1;
%     %% ��ȡLookup�궨��
%     lookups =  find_system(names,'FindAll','on','BlockType','Lookup_n-D');
%     if isempty(lookups)
%         LookUp_1Dims ={};
%         LookUp_2Dims = {};
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
%                 last_str = LookUp_2Dim_Tables(sym_Id(end)+1:end); %��ȡ���һ���ؼ���
%                 Ids = strcmpi(last_str,key_str(:,1));%���һ���ؼ��ֲ�ѯ
%                 verify_Id = find(Ids);%���һ���ؼ���IDȷ��
%                 first_str = LookUp_2Dim_Tables(sym_Id(1)+1:sym_Id(2)-1); %��ȡ�ź�����
%                 first_str_Id = strcmpi(first_str,key_str(:,1));%�ź����Բ�ѯ
%                 verify_first_strId = find(first_str_Id);%�ź�����IDȷ��
%                 if ~isempty(verify_Id)
%                     Con_Values_value = num2str(key_str{verify_Id,2});
%                     Con_Values_unit = key_str{verify_Id,3};
%                     Con_Values_min = num2str(key_str{verify_Id,4});
%                     Con_Values_max = num2str(key_str{verify_Id,5});
%                     Con_Values_type = key_str{verify_Id,6};
%                     Con_Values_dec = key_str{verify_Id,7};
%                     Comm_Info_2D{j,1} = {LookUp_2Dim_Tables,Con_Values_value,Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
%                 else  if isempty(verify_Id)&&~isempty(verify_first_strId)
%                         Con_Values_value = num2str(key_str{verify_first_strId,2});
%                         Con_Values_unit = key_str{verify_first_strId,3};
%                         Con_Values_min = num2str(key_str{verify_first_strId,4});
%                         Con_Values_max = num2str(key_str{verify_first_strId,5});
%                         Con_Values_type = key_str{verify_first_strId,6};
%                         Con_Values_dec = key_str{verify_first_strId,7};
%                         Comm_Info_2D{j,1} = {LookUp_2Dim_Tables,Con_Values_value,Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
%                     else
%                         Comm_Info_2D{j,1} = {LookUp_2Dim_Tables,'[0 0 0]','Dft','0','1','single',' '};
%                     end
%                 end
%                 j = j+1;
%                 %-----------------------------------------------------------------------
%                 LookUp_2Dim_BreakPoints1= get_param(hands,'BreakpointsForDimension1');
%                 %-----------------------------------------------------------
%                 sym_Id = strfind(LookUp_2Dim_BreakPoints1,'_');
%                 last_str = LookUp_2Dim_BreakPoints1(sym_Id(end)+1:end); %��ȡ���һ���ؼ���
%                 Ids = strcmpi(last_str,key_str(:,1));%���һ���ؼ��ֲ�ѯ
%                 verify_Id = find(Ids);%���һ���ؼ���IDȷ��
%                 first_str = LookUp_2Dim_BreakPoints1(sym_Id(1)+1:sym_Id(2)-1); %��ȡ�ź�����
%                 first_str_Id = strcmpi(first_str,key_str(:,1));%�ź����Բ�ѯ
%                 verify_first_strId = find(first_str_Id);%�ź�����IDȷ��
%                 if ~isempty(verify_Id)
%                     Con_Values_value = num2str(key_str{verify_Id,2});
%                     Con_Values_unit = key_str{verify_Id,3};
%                     Con_Values_min = num2str(key_str{verify_Id,4});
%                     Con_Values_max = num2str(key_str{verify_Id,5});
%                     Con_Values_type = key_str{verify_Id,6};
%                     Con_Values_dec = key_str{verify_Id,7};
%                     Comm_Info_2D_X{jj,1} = {LookUp_2Dim_BreakPoints1,Con_Values_value,Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
%                 else  if isempty(verify_Id)&&~isempty(verify_first_strId)
%                         Con_Values_value = num2str(key_str{verify_first_strId,2});
%                         Con_Values_unit = key_str{verify_first_strId,3};
%                         Con_Values_min = num2str(key_str{verify_first_strId,4});
%                         Con_Values_max = num2str(key_str{verify_first_strId,5});
%                         Con_Values_type = key_str{verify_first_strId,6};
%                         Con_Values_dec = key_str{verify_first_strId,7};
%                         Comm_Info_2D_X{jj,1} = {LookUp_2Dim_BreakPoints1,Con_Values_value,Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
%                     else
%                         Comm_Info_2D_X{jj,1} = {LookUp_2Dim_BreakPoints1,'[0 0 0]','Dft','0','1','single',' '};
%                     end
%                 end
%                 jj = jj+1;
%                 %-----------------------------------------------------------------------
%                 LookUp_2Dim_BreakPoints2 = get_param(hands,'BreakpointsForDimension2');
% %                 count = count+1;
% %                 [Propertys1] = Comm(LookUp_2Dim_BreakPoints2,count);
%                 %-----------------------------------------------------------
%                 sym_Id = strfind(LookUp_2Dim_BreakPoints2,'_');
%                 last_str = LookUp_2Dim_BreakPoints2(sym_Id(end)+1:end); %��ȡ���һ���ؼ���
%                 Ids = strcmpi(last_str,key_str(:,1));%���һ���ؼ��ֲ�ѯ
%                 verify_Id = find(Ids);%���һ���ؼ���IDȷ��
%                 first_str = LookUp_2Dim_BreakPoints2(sym_Id(1)+1:sym_Id(2)-1); %��ȡ�ź�����
%                 first_str_Id = strcmpi(first_str,key_str(:,1));%�ź����Բ�ѯ
%                 verify_first_strId = find(first_str_Id);%�ź�����IDȷ��
%                 if ~isempty(verify_Id)
%                     Con_Values_value = num2str(key_str{verify_Id,2});
%                     Con_Values_unit = key_str{verify_Id,3};
%                     Con_Values_min = num2str(key_str{verify_Id,4});
%                     Con_Values_max = num2str(key_str{verify_Id,5});
%                     Con_Values_type = key_str{verify_Id,6};
%                     Con_Values_dec = key_str{verify_Id,7};
%                     Comm_Info_2D_Y{jjj,1} = {LookUp_2Dim_BreakPoints2,Con_Values_value,Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
%                 else  if isempty(verify_Id)&&~isempty(verify_first_strId)
%                         Con_Values_value = num2str(key_str{verify_first_strId,2});
%                         Con_Values_unit = key_str{verify_first_strId,3};
%                         Con_Values_min = num2str(key_str{verify_first_strId,4});
%                         Con_Values_max = num2str(key_str{verify_first_strId,5});
%                         Con_Values_type = key_str{verify_first_strId,6};
%                         Con_Values_dec = key_str{verify_first_strId,7};
%                         Comm_Info_2D_Y{jjj,1} = {LookUp_2Dim_BreakPoints2,Con_Values_value,Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
%                     else
%                         Comm_Info_2D_Y{jjj,1} = {LookUp_2Dim_BreakPoints2,'[0 0 0]','Dft','0','1','single',' '};
%                     end
%                 end
%                 jjj = jjj+1;
%                 %-----------------------------------------------------------------------
%                 LookUp_2Dims{n,1} = {LookUp_2Dim_Tables,LookUp_2Dim_BreakPoints1,LookUp_2Dim_BreakPoints2};
%                 n = n+1;
%             else
%                 hands = lookups(i,1);
%                 LookUp_1Dim_Tables= get_param(hands,'Table');
%                 LookUp_1Dim_BreakPoints1= get_param(hands,'BreakpointsForDimension1');
%                 LookUp_1Dims{m,1} = {LookUp_1Dim_Tables,LookUp_1Dim_BreakPoints1};
%                 m = m+1;
%             end
%         end
%     end
% %     disp(['Constants Num:   ',num2str(count),';','Gen_Con_Num:   ',num2str(length(Con_Values_Valid))]);
%     disp(['1-D MapNum:       ',num2str(length(LookUp_1Dims)),';','    2-D MapNum:       ',num2str(length(LookUp_2Dims))]);
%     %% ��ȡRelay�궨��
%     relays =  find_system('evc','FindAll','on','BlockType','Relay');
%     if isempty(relays)
%         Relay_Values= {};
%     else
%         k =1;
%         for i = 1:length(relays)
%             Relay_Values_On = get_param(relays(i,1),'OnSwitchValue');
%             %-----------------------------------------------------------
%                 sym_Id = strfind(Relay_Values_On,'_');
%                 last_str = Relay_Values_On(sym_Id(end)+1:end); %��ȡ���һ���ؼ���
%                 Ids = strcmpi(last_str,key_str(:,1));%���һ���ؼ��ֲ�ѯ
%                 verify_Id = find(Ids);%���һ���ؼ���IDȷ��
%                 first_str = Relay_Values_On(sym_Id(1)+1:sym_Id(2)-1); %��ȡ�ź�����
%                 first_str_Id = strcmpi(first_str,key_str(:,1));%�ź����Բ�ѯ
%                 verify_first_strId = find(first_str_Id);%�ź�����IDȷ��
%                 if ~isempty(verify_Id)
%                     Con_Values_value = num2str(key_str{verify_Id,2});
%                     Con_Values_unit = key_str{verify_Id,3};
%                     Con_Values_min = num2str(key_str{verify_Id,4});
%                     Con_Values_max = num2str(key_str{verify_Id,5});
%                     Con_Values_type = key_str{verify_Id,6};
%                     Con_Values_dec = key_str{verify_Id,7};
%                     Comm_Info_RelyOn{jjjj,1} = {Relay_Values_On,Con_Values_value,Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
%                 else  if isempty(verify_Id)&&~isempty(verify_first_strId)
%                         Con_Values_value = num2str(key_str{verify_first_strId,2});
%                         Con_Values_unit = key_str{verify_first_strId,3};
%                         Con_Values_min = num2str(key_str{verify_first_strId,4});
%                         Con_Values_max = num2str(key_str{verify_first_strId,5});
%                         Con_Values_type = key_str{verify_first_strId,6};
%                         Con_Values_dec = key_str{verify_first_strId,7};
%                         Comm_Info_RelyOn{jjjj,1} = {Relay_Values_On,Con_Values_value,Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
%                     else
%                         Comm_Info_RelyOn{jjjj,1} = {Relay_Values_On,'0','Dft','0','1','single',' '};
%                     end
%                 end
%                 jjjj = jjjj+1;
%                 %-----------------------------------------------------------------------
%             Relay_Values_Off = get_param(relays(i,1),'OffSwitchValue');
%                         %-----------------------------------------------------------
%                 sym_Id = strfind(Relay_Values_Off,'_');
%                 last_str = Relay_Values_Off(sym_Id(end)+1:end); %��ȡ���һ���ؼ���
%                 Ids = strcmpi(last_str,key_str(:,1));%���һ���ؼ��ֲ�ѯ
%                 verify_Id = find(Ids);%���һ���ؼ���IDȷ��
%                 first_str = Relay_Values_Off(sym_Id(1)+1:sym_Id(2)-1); %��ȡ�ź�����
%                 first_str_Id = strcmpi(first_str,key_str(:,1));%�ź����Բ�ѯ
%                 verify_first_strId = find(first_str_Id);%�ź�����IDȷ��
%                 if ~isempty(verify_Id)
%                     Con_Values_value = num2str(key_str{verify_Id,2});
%                     Con_Values_unit = key_str{verify_Id,3};
%                     Con_Values_min = num2str(key_str{verify_Id,4});
%                     Con_Values_max = num2str(key_str{verify_Id,5});
%                     Con_Values_type = key_str{verify_Id,6};
%                     Con_Values_dec = key_str{verify_Id,7};
%                     Comm_Info_RelyOff{jjjjj,1} = {Relay_Values_Off,Con_Values_value,Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
%                 else  if isempty(verify_Id)&&~isempty(verify_first_strId)
%                         Con_Values_value = num2str(key_str{verify_first_strId,2});
%                         Con_Values_unit = key_str{verify_first_strId,3};
%                         Con_Values_min = num2str(key_str{verify_first_strId,4});
%                         Con_Values_max = num2str(key_str{verify_first_strId,5});
%                         Con_Values_type = key_str{verify_first_strId,6};
%                         Con_Values_dec = key_str{verify_first_strId,7};
%                         Comm_Info_RelyOff{jjjjj,1} = {Relay_Values_Off,Con_Values_value,Con_Values_unit,Con_Values_min,Con_Values_max,Con_Values_type,Con_Values_dec};
%                     else
%                         Comm_Info_RelyOff{jjjjj,1} = {Relay_Values_Off,'0','Dft','0','1','single',' '};
%                     end
%                 end
%                 jjjjj = jjjjj+1;
%                 %-----------------------------------------------------------------------
%             
%             Relay_Values{k,1} = {Relay_Values_On,Relay_Values_Off};
%             k = k+1;
%         end
%     end
% %         disp(['Constants Num:   ',num2str(count),';   ','Gen_Con_Num:   ',num2str(length(Con_Values_Valid))]);
%         disp(['Relay Num:            ',num2str(length(Relay_Values))]);
end
%     function [Propertys] = Comm(names,rolls)
%         global key_str  
%         sym_Id = strfind(names,'_');
%         last_str = names(sym_Id(end)+1:end); %��ȡ���һ���ؼ���
%         Ids = strcmpi(last_str,key_str(:,1));%���һ���ؼ��ֲ�ѯ
%         verify_Id = find(Ids);%���һ���ؼ���IDȷ��
%         first_str = names(sym_Id(1)+1:sym_Id(2)-1); %��ȡ�ź�����
%         first_str_Id = strcmp(first_str,key_str(:,1));%�ź����Բ�ѯ
%         verify_first_strId = find(first_str_Id);%�ź�����IDȷ��
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