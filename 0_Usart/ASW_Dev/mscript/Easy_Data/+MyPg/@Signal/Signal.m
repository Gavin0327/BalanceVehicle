classdef Signal  <  mpt.Signal
    %Created by ZhangXiaosong in ATECH
    
  methods
      function setupCoderInfo(h)
          
          useLocalCustomStorageClasses(h, 'MyPg');
      end
      
      %------------------------------------------------
      function h = Signal(varargin)
          
          h.RTWInfo.StorageClass = 'Custom';
      end
  
  end 
end 
