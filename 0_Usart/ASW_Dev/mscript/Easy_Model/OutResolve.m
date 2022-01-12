function OutResolve
%将ARECH信号重新命名，功能实现策略：
%1、按照模型层级关系和信号流方向逐级进行重命名；
%2、取消原有输出信号关联和信号线名称；该步通过3即可实现；
%3、更新新的端口名称到信号线名称然后关联；
%重命名
% outport_blocks=  find_system(gcs,'SearchDepth','1','BlockType','Outport');
% for i = 1:length(outport_blocks)
%     h_s = get_param(outport_blocks{i},'Handle');
%     org_name = get_param(h_s,'Name');
%     buff_name = org_name(5:end);
%     new_name = ['vild' '_' buff_name];
%     set_param(h_s,'Name',new_name);
% end
% 更新
outport_blocks=  find_system(gcs,'SearchDepth','1','BlockType','Outport');
for i=1:length(outport_blocks) %输出线数据关联与输入不同，需要关注
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

