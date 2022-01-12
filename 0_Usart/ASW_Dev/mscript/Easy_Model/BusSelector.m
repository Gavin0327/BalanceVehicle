%current_sub = get_param(gcs,'CurrentBlock');
nums = evalin('base','num');
numstr = num2str(nums);
busname = strcat('BusNum',numstr);
sub_name = gcb;
path = find_system(gcbh,  'SearchDepth', 1, 'BlockType', 'Inport');
inport_names = get_param(path,'name');
sub_pos = get_param(sub_name,'position');
block_name = [gcs,'/',busname];
block_pos = [sub_pos(1,1)-190 sub_pos(1,2)-3 sub_pos(1,1)-190+5 sub_pos(1,4)+3];
busH = add_block('simulink/Signal Routing/Bus Selector',block_name,'Position',block_pos);
num = num+1;
% for i = 1:length(inport_names)
%     str = inport_names{i,1};
%     if i <length(inport_names)
%     str_1 = [str,','];
%     else
%         str_1 = str;
%     end
%     bus_outports = strcat(str1);
% end
% input_path = [gcs,'/VCI_Inputs'];
add_line(gcs,'VCI_Inputs/1',[busname,'/1'],'autorouting','smart');
% set(busH,'OutputSignals',b);
