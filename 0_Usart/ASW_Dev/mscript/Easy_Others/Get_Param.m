Sub_Path = find_system(bdroot,'SearchDepth', 1,'BlockType','SubSystem');
for t = 1:length(Sub_Path)
    Sub_Path_Name = Sub_Path{t,1};
    str = strfind(Sub_Path_Name,'_');
    if ~isempty(str)
All_Con =  find_system(Sub_Path,'FindAll','on','BlockType','Constant');
All_Relay =  find_system(Sub_Path,'FindAll','on','BlockType','Relay');
All_LookUp =  find_system(Sub_Path,'FindAll','on','BlockType','Lookup_n-D');
    end
end
