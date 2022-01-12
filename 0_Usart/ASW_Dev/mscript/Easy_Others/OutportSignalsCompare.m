%find_system(gcs,  'SearchDepth', 1, 'BlockType', 'Outport');
for i = 1:length(a)
    str_id = strfind(a{i,1},'/');
    a_names{i,1} = a{i,1}(str_id(1,end)+1:end);
end
for i = 1:length(b)
    str_id1 = strfind(b{i,1},'/');
    b_names{i,1} = b{i,1}(str_id1(1,end)+1:end);
end
diff_names = setdiff(a_names,b_names);