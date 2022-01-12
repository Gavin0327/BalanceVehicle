out_signals = get_param('Copy_of_VCU_Integration_EMO_NewArch/VCU/BusSelector','PortHandles');
outH = out_signals.Outport;
for i = 1:length(outH)
    name = get_param(outH(1,i),'name');
    out_name = name(2:end-1);
    block_name = ['Copy_of_VCU_Integration_EMO_NewArch/VCU','/',out_name];
    add_block('simulink/Sinks/Out1',block_name,'Position',[1360  388+(i-1)*30 1390  402+(i-1)*30]);
    outnum = ['BusSelector/',num2str(i)];
    signum = [out_name,'/1'];
    hh = add_line(gcs,outnum,signum,'autorouting','smart');
    %set(hh,'signalPropagation','off','name','');
end