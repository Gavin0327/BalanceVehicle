function CostantSize
constant_blocks = find_system(gcs,  'SearchDepth', 1, 'BlockType', 'Constant');
for i = 1:length(constant_blocks)
    pos = get_param(constant_blocks{i,1},'position');
    cen_pos = ((pos(1,4)-pos(1,2))/2)+pos(1,2);
    new_pos = [pos(1,1),cen_pos-8,pos(1,3),cen_pos+8];
    set_param(constant_blocks{i,1},'position',new_pos);
end
end