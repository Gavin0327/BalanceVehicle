classdef Parameter < mpt.Parameter
  properties(Hidden = 1)
    GenericProperty = [];
  end

   methods
     function setupCoderInfo(h)
       % Use custom storage classes from this package
       useLocalCustomStorageClasses(h, 'STM32');
     end
   end % methods
  
  methods
    %---------------------------------------------------------------------------
    function h = Parameter(varargin)
        %PARAMETER  Class constructor.
        
        % Call superclass constructor with variable arguments
        h@mpt.Parameter(varargin{:});      
    end % End of constructor
    
  end % End of Public methods
  
  methods (Access=protected)
    %---------------------------------------------------------------------------
    function retVal = copyElement(obj)
    %COPYELEMENT  Define special copy behavior for properties of this class.
    %             See matlab.mixin.Copyable for more details.
      retVal = copyElement@Simulink.Parameter(obj);
      if isobject(obj.GenericProperty)
        retVal.GenericProperty = copy(obj.GenericProperty);
      end
    end
  end % Protected methods
end % classdef
