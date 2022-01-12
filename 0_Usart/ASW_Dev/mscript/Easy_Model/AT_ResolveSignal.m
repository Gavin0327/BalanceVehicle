function AT_ResolveSignal
%     set(find_system(gcs,'findall','on','Type','line'),'MustResolveToSignalObject',0)
inport_blocks = find_system(gcs,  'SearchDepth', 1, 'BlockType', 'Inport');
outport_blocks = find_system(gcs,  'SearchDepth', 1, 'BlockType', 'Outport');
for i=1:length(inport_blocks)
    ph = get_param(inport_blocks{i}, 'PortHandles');
    Id_str = strfind(inport_blocks{i},'/');
    last_str = Id_str(1,end);
    name_sig = inport_blocks{i}(last_str+1:end);
    set_param(ph.Outport,'Name',name_sig);
    set(ph.Outport, 'MustResolveToSignalObject',true) ;
end
for i=1:length(outport_blocks) %输出线数据关联与输入不同，需要关注
    ph1 = get_param(outport_blocks{i}, 'PortHandles');
    signal_name = get_param(ph1.Inport,'Name');
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