%--------------------------The Nums of ATECH Constants------------------%
modle_name= 'VCU_Integration_EMO1';
%consts = find_system(modle_name,'findall','on','Type','Constant');
% consts = find_system(modle_name,  'SearchDepth', 1, 'BlockType', 'Constant');
consts = find_system(modle_name,'regexp','on','blocktype','Constant'); %使用正则查找模型中所有Constant模块，返回值是模块路径
n = 1;
k = 1;
for i = 1:length(consts)
    cal_names{i,1} = get_param(consts{i,1},'Value');
    if ~isempty(str2num(cal_names{i,1}))
        con_cals_values{n,1} = cal_names{i,1};
        n = n+1;
    else
        if ~strcmp(cal_names{i,1},'KeINP_BSWMode_enum')
        def_cals_names{k,1} = cal_names{i,1};
        k = k+1;
        end
    end
end
uni_cals_atech = unique(def_cals_names);
% disp(['Total Cal Nnums is : ',num2str(length(consts))]);
% disp(['Define Cal Nums is : ',num2str(length(def_cals_names))]);
% disp(['Constant Cal Nums is : ',num2str(length(con_cals_values))]);
% disp(['Sum is ： ',num2str(length(def_cals_names)+length(con_cals_values))]);
%----------------------------------The Nums of UFO-----------------%
modle_name1= 'Copy_of_VCU_Integration_EMO_NewArch';
consts1 = find_system(modle_name1,'regexp','on','blocktype','Constant'); %使用正则查找模型中所有Constant模块，返回值是模块路径
n = 1;
k = 1;
for i = 1:length(consts1)
    cal_names1{i,1} = get_param(consts1{i,1},'Value');
    if ~isempty(str2num(cal_names1{i,1}))
        con_cals_values1{n,1} = cal_names1{i,1};
        n = n+1;
    else
        if ~strcmp(cal_names1{i,1},'KeINP_BSWMode_enum')
        def_cals_names1{k,1} = cal_names1{i,1};
        k = k+1;
        end
    end
end
uni_cals_ufo = unique(def_cals_names1);
%------------------------The difference of ATECH and UFO-----------%
diff_cals = setdiff(uni_cals_ufo,uni_cals_atech);