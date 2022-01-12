%------------------------------------1.VCU输入输出信号获取----------------------------------%
%模型输入信号获取:CAN+HW
M_In_path = find_system('VCU_Integration_EMO', 'SearchDepth', 1,'BlockType', 'Inport');
Sprit_ID = strfind(M_In_path{1,1},'/');
VCU_Inports = {};
bsw_nums = 0;
for i=1:length(M_In_path)
    buf = M_In_path{i,1};
    VCU_Inports{i,1} = buf(Sprit_ID+1:end);
    expression = 'In_\w*';
    matchStr = regexp(buf,expression,'match');
    if ~isempty(matchStr)
        bsw_nums = bsw_nums+1;
    end
end
%模型输出信号获取:CAN+HW
M_Out_path = find_system('VCU_Integration_EMO/DIR_OUT','FindAll','on','type','line');
M_Out_path_name = {};
n =1;
for i = 1:length(M_Out_path)%HW
    buf = get_param(M_Out_path(i,1),'name');
    expression = 'Out\w*';
    matchStr = regexp(buf,expression,'match');
    if ~isempty(matchStr)
        M_Out_path_name{n,1} = buf;
        n = n+1;
    end
end
M_Out_path = find_system('VCU_Integration_EMO/CAN_OUTP','FindAll','on','type','line');
M_Out_path_name1 = {};
nn =1;
for ii = 1:length(M_Out_path)%CAN
    buf = get_param(M_Out_path(ii,1),'name');
    expression = '^[A-Z]*_\w*';
    matchStr = regexp(buf,expression,'match');
    if ~isempty(matchStr)
        M_Out_path_name1{nn,1} = buf;
        nn = nn+1;
    end
end
buf1 = unique(M_Out_path_name1);
VCU_Outports = cat(1,M_Out_path_name,buf1);

%------------------------------------2.Top Layer Model Build----------------------------------%
module_name = 'VCU_Integration_EMO_NewArch';
CAN_Nodes = {'IPU','[0.00,0.45,0.74]';'BMS','[1.00,0.00,1.00]';'OBC','[0.37,0.52,0.16]';...
    'DCDC','[0.30,0.75,0.93]';'HDM','[0.30,0.75,0.93]';'ABS','[0.93,0.69,0.13]';'EPS',...
    '[1.00,0.41,0.16]';'CLM','[0.00,1.00,1.00]';'AC','[0.00,1.00,1.00]';'TBOX',...
    '[0.96,1.00,0.00]';'BCM','[1.00,0.80,0.00]';'VbBSW','red'};
%--------------------VCU顶层输入信号-----------------------%
%b_sysStartSrc
add_block('simulink/Sources/In1','VCU_Integration_EMO_NewArch/b_sysStartSrc','Position',[635 143+35 665 157+35],'BackgroundColor','[0.45,1.00,0.00]');
%硬件输入
for in = 2:(bsw_nums+1)
    in_name = VCU_Inports{in,1};
    block_name = [module_name,'/',in_name];
    add_block('simulink/Sources/In1',block_name,'Position',[635 143+35*in 665 157+35*in],'BackgroundColor','[0.65,0.65,0.65]');
end
%CAN输入
for in = (bsw_nums+2):length(VCU_Inports)
    flg = 0;
    in_name = VCU_Inports{in,1};
    for c = 1:length(CAN_Nodes)
        expression = ['^',CAN_Nodes{c,1},'\w*'];
        matchStr = regexp(in_name,expression,'match');
        if ~isempty(matchStr)
            flg = 1;
            block_name = [module_name,'/',in_name];
            add_block('simulink/Sources/In1',block_name,'Position',[635 143+35*in 665 157+35*in],'BackgroundColor',CAN_Nodes{c,2});
        end
    end
    if flg == 0
        block_name = [module_name,'/',in_name];
        add_block('simulink/Sources/In1',block_name,'Position',[635 143+35*in 665 157+35*in],'BackgroundColor','[1.00,1.00,1.00]');
    end
end
%--------------------VCU顶层输出信号-----------------------%
Out_Node = {'Out','[0.65,0.65,0.65]';'IPU','[0.00,0.45,0.74]';'BMS','[1.00,0.00,1.00]';...
    'VCU_ABS','[0.30,0.75,0.93]';'VCU_BMS','[0.30,0.75,0.93]';'VCU_DCDC','[0.93,0.69,0.13]';'VCU_Battery',...
    '[1.00,0.41,0.16]';'VCU_Break','[0.00,1.00,1.00]';'VCU_EPS','[0.00,1.00,1.00]';'VCU_HDM',...
    '[0.96,1.00,0.00]';'VCU_OBC','[1.00,0.80,0.00]'};
for out = 1:length(VCU_Outports)
    flg = 0;
    out_name = VCU_Outports{out,1};
    for c1 = 1:length(Out_Node)
        expression = ['^',Out_Node{c1,1},'\w*'];
        matchStr = regexp(out_name,expression,'match');
        if ~isempty(matchStr)
            flg = 1;
            block_name = [module_name,'/',out_name];
            add_block('simulink/Sinks/Out1',block_name,'Position',[1360 178+35*(out-1) 1390 192+35*(out-1)],'BackgroundColor',Out_Node{c1,2});
        end
    end
    if flg == 0
        block_name = [module_name,'/',out_name];
        add_block('simulink/Sinks/Out1',block_name,'Position',[1360 178+35*(out-1) 1390 192+35*(out-1)],'BackgroundColor','[1.00,1.00,1.00]');
    end
end


