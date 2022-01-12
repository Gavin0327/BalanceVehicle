function Gen_Ports
sub_path = gcb;
sub_pos = get_param(sub_path,'position');%[left top right bottom]
sub_name =get_param(gcbh,'name');
Inports = find_system(gcbh,  'SearchDepth', 1, 'BlockType', 'Inport');
Outports = find_system(gcbh,  'SearchDepth', 1, 'BlockType', 'Outport');
%% Inport
Inport_names = get_param(Inports,'name');
if ischar(Inport_names)
    inport_name = [gcs,'/',Inport_names];
    inport_pos = [sub_pos(1,1)-245 sub_pos(1,2)-((sub_pos(1,2)-sub_pos(1,4))/2+7) sub_pos(1,1)-215 sub_pos(1,4)+((sub_pos(1,2)-sub_pos(1,4))/2+7)];
    add_block('simulink/Sources/In1',inport_name,'Position',inport_pos);
    signalLines = add_line(gcs,[Inport_names,'/1'],[sub_name,'/1'],'autorouting','smart');
%     set_param(signalLines,'Name',Inport_names);
%     set(signalLines,'signalPropagation','on')
else
    for i = 1:length(Inport_names)  
    inport_name = [gcs,'/',Inport_names{i,1}];
    inport_pos = [sub_pos(1,1)-245 sub_pos(1,2)+10+40*(i-1) sub_pos(1,1)-215 sub_pos(1,2)+10+40*(i-1)+14];
    add_block('simulink/Sources/In1',inport_name,'Position',inport_pos);
    signalLines = add_line(gcs,[Inport_names{i,1},'/1'],[sub_name,'/',num2str(i)],'autorouting','smart');
    end
end
%% Outport
Outport_names = get_param(Outports,'name');
if ischar(Outport_names)
    outport_name = [gcs,'/',Outport_names];
    inport_pos = [sub_pos(1,1)+505 sub_pos(1,2)-((sub_pos(1,2)-sub_pos(1,4))/2+7) sub_pos(1,1)+535 sub_pos(1,4)+((sub_pos(1,2)-sub_pos(1,4))/2+7)];
    add_block('simulink/Sinks/Out1',outport_name,'Position',inport_pos);
    signalLines = add_line(gcs,[sub_name,'/1'],[Outport_names,'/1'],'autorouting','smart');
    set(signalLines,'signalPropagation','off')
%     set_param(signalLines,'Name',Inport_names);
%     set(signalLines,'signalPropagation','on')
else
    for i = 1:length(Outport_names)  
    outport_name = [gcs,'/',Outport_names{i,1}];
    inport_pos = [sub_pos(1,1)+505 sub_pos(1,2)+10+40*(i-1) sub_pos(1,1)+535 sub_pos(1,2)+10+40*(i-1)+14];
    add_block('simulink/Sinks/Out1',outport_name,'Position',inport_pos);
    signalLines = add_line(gcs,[sub_name,'/',num2str(i)],[Outport_names{i,1},'/1'],'autorouting','smart');
    set(signalLines,'signalPropagation','off')
    end
end
end
