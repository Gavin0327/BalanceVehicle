function OutResolve
%��ARECH�ź���������������ʵ�ֲ��ԣ�
%1������ģ�Ͳ㼶��ϵ���ź��������𼶽�����������
%2��ȡ��ԭ������źŹ������ź������ƣ��ò�ͨ��3����ʵ�֣�
%3�������µĶ˿����Ƶ��ź�������Ȼ�������
%������
% outport_blocks=  find_system(gcs,'SearchDepth','1','BlockType','Outport');
% for i = 1:length(outport_blocks)
%     h_s = get_param(outport_blocks{i},'Handle');
%     org_name = get_param(h_s,'Name');
%     buff_name = org_name(5:end);
%     new_name = ['vild' '_' buff_name];
%     set_param(h_s,'Name',new_name);
% end
% ����
outport_blocks=  find_system(gcs,'SearchDepth','1','BlockType','Outport');
for i=1:length(outport_blocks) %��������ݹ��������벻ͬ����Ҫ��ע
    ph1 = get_param(outport_blocks{i}, 'PortHandles');
    block_pc = get_param(outport_blocks{i}, 'PortConnectivity');
    src_ph = get_param(block_pc.SrcBlock, 'PortHandles');
    src_outports = src_ph.Outport;
    if length(src_outports)>1
        for i = 1:length(src_outports)
        Id_str = strfind(outport_blocks{i},'/');
        last_str = Id_str(1,end);
        name_sig = outport_blocks{i}(last_str+1:end);
        %set_param(ph1.Inport,'Name',name_sig);
        set_param(src_outports(1,i),'Name',name_sig);
        %set(ph1.Inport, 'MustResolveToSignalObject',true) ;
        set(src_outports(1,i), 'MustResolveToSignalObject',true) ;
        end
    else
        Id_str = strfind(outport_blocks{i},'/');
        last_str = Id_str(1,end);
        name_sig = outport_blocks{i}(last_str+1:end);
        %set_param(ph1.Inport,'Name',name_sig);
        set_param(src_outports,'Name',name_sig);
        %set(ph1.Inport, 'MustResolveToSignalObject',true) ;
        set(src_outports, 'MustResolveToSignalObject',true) ;
    end
end
end

