function GetPorts
% 信号关联查询
all_in =  find_system('VCU_Integration_EMO','FindAll','on','BlockType','Inport');
all_out =  find_system('VCU_Integration_EMO','FindAll','on','BlockType','Outport');
for i = 1:length(all_in)
    in_name{i,1} = get_param(all_in(i,1),'name');
    ph  = get_param(all_in(i,1), 'PortHandles');
    resIn_valid{i,1} = get(ph.Outport, 'MustResolveToSignalObject');%判断信号是否关联
end
in_names = cat(2,in_name,resIn_valid);
for i = 1:length(all_out)
    out_name{i,1} = get_param(all_out(i,1),'name');
    ph  = get_param(all_out(i,1), 'PortHandles');
    resOut_valid{i,1} = get(ph.Outport, 'MustResolveToSignalObject');%判断信号是否关联
end
out_names = cat(2,out_name,resOut_valid);
all_name = cat(1,in_name,out_name);
all_res  = cat(1,resIn_valid,resOut_valid);
% a = Simulink.findVars('VCU_Integration_EMO_Old');
S = whos('-file','New1.mat');
for k = 1:length(S)
%    disp(['  ' S(k).name ...
%          '  ' mat2str(S(k).size) ...
%          '  ' S(k).class]);
resvol_names{k,1} = S(k).name;
end
[diff_names,Id] = setdiff(all_name,resvol_names);
for i = 1:length(Id)
    res_s{i,1} = all_res{Id(i,1),1};
end
disp_meg = cat(2,diff_names,res_s);
filename = 'NewAddSignals.xlsx';
xlswrite(filename,disp_meg);
end