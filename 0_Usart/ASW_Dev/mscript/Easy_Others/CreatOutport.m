function BusSelectorToPort
outport_blocks = find_system(gcs,  'SearchDepth', 2, 'BlockType', 'Outport');
for i=1:length(outport_blocks)
    str_id = strfind(outport_blocks{i,1},'/');
    sig_name = outport_blocks{i,1}(str_id(1,end)+1:end);
    block_name = [gcs,'/',sig_name];
    add_block('simulink/Sinks/Out1',block_name,'Position',[1580 283+(i-1)*35 1610 297+(i-1)*35]);
    outnum = ['VCU/',num2str(i)];
    signum = [sig_name,'/1'];
    add_line(gcs,outnum,signum,'autorouting','smart');
end
end