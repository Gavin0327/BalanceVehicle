function load_feat_path_and_cal(features_dir)
% path_sum ={'vil__vcu_input_layer';...
%            'vol__vcu_output_layer';...
%            fullfile(features_dir,'vsl__vcu_strategy_layer')};
filtered_dirs = find_feature_candidates(features_dir);
for i = 1:length(filtered_dirs)
    this_feat_dir=filtered_dirs{i};
    load_feature_items(features_dir,this_feat_dir);
end
end

function load_feature_items(parent_dir,this_feat_dir)
% Loads the feature data in directory named this_feat_dir, adding to path
% features_dir is the full path to the parent directory
    full_feat_path=fullfile(parent_dir,this_feat_dir);
    addpath(full_feat_path);
    warning('off','backtrace');
    % Extract feature acronym
    feature_st = regexp(this_feat_dir, '(?<name>\w+)__.*', 'names');
    if ~isempty(feature_st)
        featurename_s = feature_st.name;
        % Look for <feature>_config.m file and run if found
        config_file = [featurename_s '_config'];
        cal_file = [featurename_s '_cal'];
        var_file = [featurename_s '_var'];
        if exist(config_file,'file')
            evalin('base',config_file);
        else
            warning(['no exist ',config_file,' file!']);     
        end
            
        if exist(cal_file,'file')
            evalin('base',cal_file);
        else
            warning(['no exist ',cal_file,' file!']);
        end
        
        if exist(var_file,'file')
            evalin('base',var_file);
        else
            warning(['no exist ',var_file,' file!']);
        end
        
        % Load sub-features
        if isdir(full_feat_path)
            load_feat_path_and_cal(full_feat_path);%This is Recursion,Usefull in for function
        end
    end
end

function filtered_dirs=find_feature_candidates(features_dir)
dirs = dir(features_dir);
filtered_dirs = [];
for i = 1:length(dirs)
    if ~strcmp(dirs(i).name, '.') && ~strcmp(dirs(i).name, '..')
        p = fullfile(features_dir,dirs(i).name);
        if isdir(p)
            filtered_dirs = [filtered_dirs; {dirs(i).name}]; %This is Recursion
        end
    end
end
end