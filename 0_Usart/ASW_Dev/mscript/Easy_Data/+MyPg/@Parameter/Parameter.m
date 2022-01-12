classdef Parameter  <  mpt.Parameter
    %Created by ZhangXiaosong in ATECH
    
  methods
      function setupCoderInfo(h)
          
          useLocalCustomStorageClasses(h, 'MyPg');
      end
      
      %------------------------------------------------
      function h = Parameter(varargin)
          
          h.RTWInfo.StorageClass = 'Custom';
      end
  
  end 
end 
