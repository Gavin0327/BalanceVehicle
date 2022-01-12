nums = evalin('base','num');
numstr = num2str(nums);
busname = strcat('BusNum',numstr);
sub_path = gcb;
sub_name =get_param(gcbh,'name');

path = find_system(gcbh,  'SearchDepth', 1, 'BlockType', 'Outport');
Outport_names = get_param(path,'name');
if ischar(Outport_names)
    sub_pos = get_param(sub_path,'position');
    block_name = [gcs,'/',busname];
    block_pos = [sub_pos(1,1)+535 sub_pos(1,2)+1 sub_pos(1,1)+535+5 sub_pos(1,4)-1];
    busH = add_block('simulink/Signal Routing/Bus Creator',block_name,'Position',block_pos,'Inputs','1');
    signalLines = add_line(gcs,[sub_name,'/1'],[busname,'/1'],'autorouting','smart');
    set(signalLines,'signalPropagation','on')
else
    sub_pos = get_param(sub_path,'position');
    block_name = [gcs,'/',busname];
    block_pos = [sub_pos(1,1)+535 sub_pos(1,2)+1 sub_pos(1,1)+535+5 sub_pos(1,4)-1];
    busH = add_block('simulink/Signal Routing/Bus Creator',block_name,'Position',block_pos,'Inputs',num2str(length(Outport_names)));
    for i = 1:length(Outport_names)
        signalLines = add_line(gcs,[sub_name,'/',num2str(i)],[busname,'/',num2str(i)],'autorouting','smart');
        %set(signalLines,'Name',Outport_names{i,1});
        set(signalLines,'signalPropagation','on')
    end
end
num = num+1;
assignin('base','num',num);


