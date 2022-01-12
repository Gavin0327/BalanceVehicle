classdef Signal < mpt.Signal
  methods
    function setupCoderInfo(h)
      % Use custom storage classes from this package
      useLocalCustomStorageClasses(h, 'STM32');
    end
  end % methods
  
  methods (Access=protected)
    %---------------------------------------------------------------------------
    function retVal = copyElement(obj)
    %COPYELEMENT  Define special copy behavior for properties of this class.
    %             See matlab.mixin.Copyable for more details.
      retVal = copyElement@Simulink.Signal(obj);
      if isobject(obj.GenericProperty)
        retVal.GenericProperty = copy(obj.GenericProperty);
      end
    end
  end % Protected methods
  
  methods
      
      function h = Signal()
         % SIGNAL  Class constructor.
      end % End of Constructor
      
  end % End of Public methods
end % classdef
