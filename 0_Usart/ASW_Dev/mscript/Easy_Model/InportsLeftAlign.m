function InportsLeftAlign
ports = find_system(gcs,  'SearchDepth', 1, 'BlockType', 'Inport');
for i = 1:length(ports)
    pos_ports{i,1} = get_param(ports{i,1},'position');  
    left_pos(i,1) = pos_ports{i,1}(1,1);
end
left_value = min(left_pos);
for i = 1:length(ports)
    pos1 = get_param(ports{i,1},'position');
    new_pos = [left_value,pos1(1,2),left_value+30,pos1(1,4)];
    set_param(ports{i,1},'position',new_pos);  
end
end