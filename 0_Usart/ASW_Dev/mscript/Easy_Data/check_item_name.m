function [match_flg, err_s, feature_s, attribute_s, type_s] = check_item_name(name_s)
% function [name_valid_flg, error_string, feature, attribute, type] = check_item_name(name_s)
% Returns 
%    name_valid_flg = true if the supplied name matches the BP13 variable 
%                          naming convention
%    error_string   - description of error if supplied name is invalid
%    feature        - feature acronym extracted from name, if name is valid
%    attribute      - attribute character extracted from name, if name is valid
%    type           - variable type extracted from name, if name is valid

match_flg = true;
err_s = '';
feature_s = '';
type_s = '';
attribute_s = '';
feature_list_c = valid_project_feature_list;

varname_split = regexp(name_s, '(?<feature>[a-z]+)(?<attribute>[abcdfmnv])_(?<type>[a-zA-Z0-9]+)_(?<descunits>\w+).*','names');

if isempty(varname_split)
    match_flg = false; % complete mismatch
    err_s = 'name does not match required format';
    return;
end

if ~isempty(varname_split.feature)
    % check feature name
    if ~ismember(varname_split.feature, feature_list_c)
        match_flg = false; % format okay but not recognised feature name
        err_s = 'feature name not recognised';
        return;
    else
        feature_s = varname_split.feature;
    end
end

if ~isempty(varname_split.attribute)
    attribute_s = varname_split.attribute;
else
    err_s = [err_s 'attribute name not recognised'];
end

if ~isempty(varname_split.type)
    type_s = varname_split.type;
end

return
