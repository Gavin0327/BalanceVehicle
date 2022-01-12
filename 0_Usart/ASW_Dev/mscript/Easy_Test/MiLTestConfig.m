function cs = MiLTestConfig(modelName)
%---------------------------------------------------------------------------
%  MATLAB function for configuration set generated on 09-Aug-2019 09:10:20
%  MATLAB version: 9.1.0.441655 (R2016b)
%---------------------------------------------------------------------------

%open(modelName)
cs = getActiveConfigSet(modelName);

% Original configuration set version: 1.16.5
if cs.versionCompare('1.16.5') < 0
    error('Simulink:MFileVersionViolation', 'The version of the target configuration set is older than the original configuration set.');
end

% Original environment character encoding: GBK
if ~strcmpi(get_param(0, 'CharacterEncoding'), 'GBK')
    warning('Simulink:EncodingUnMatched', 'The target character encoding (%s) is different from the original (%s).',  get_param(0, 'CharacterEncoding'), 'GBK');
end

% Original configuration set target is grt.tlc
cs.switchTarget('grt.tlc','');

% Do not change the order of the following commands. There are dependencies between the parameters.
cs.set_param('Name', 'Configuration'); % Name
cs.set_param('Description', ''); % Description

% Solver
cs.set_param('StartTime', '0.0');   % Start time
cs.set_param('StopTime', 'stop_time');   % Stop time
cs.set_param('SolverType', 'Fixed-step');   % Type
cs.set_param('EnableConcurrentExecution', 'off');   % Show concurrent execution options
cs.set_param('SampleTimeConstraint', 'Unconstrained');   % Periodic sample time constraint
cs.set_param('Solver', 'ode3');   % Solver
cs.set_param('FixedStep', '0.01');   % Fixed-step size (fundamental sample time)
cs.set_param('EnableMultiTasking', 'off');   % Treat each discrete rate as a separate task
cs.set_param('AutoInsertRateTranBlk', 'off');   % Automatically handle rate transition for data transfer
cs.set_param('PositivePriorityOrder', 'off');   % Higher priority value indicates higher task priority

% Data Import/Export
cs.set_param('LoadExternalInput', 'off');   % Load external input
cs.set_param('LoadInitialState', 'off');   % Load initial state
cs.set_param('SaveTime', 'on');   % Save time
cs.set_param('TimeSaveName', 'tout');   % Time variable
cs.set_param('SaveState', 'off');   % Save states
cs.set_param('SaveFormat', 'Dataset');   % Format
cs.set_param('SaveOutput', 'on');   % Save output
cs.set_param('OutputSaveName', 'yout');   % Output variable
cs.set_param('SaveFinalState', 'off');   % Save final state
cs.set_param('SignalLogging', 'on');   % Signal logging
cs.set_param('SignalLoggingName', 'logsout');   % Signal logging name
cs.set_param('DSMLogging', 'on');   % Data stores
cs.set_param('DSMLoggingName', 'dsmout');   % Data stores logging name
cs.set_param('LoggingToFile', 'off');   % Log Dataset data to file
cs.set_param('ReturnWorkspaceOutputs', 'off');   % Single simulation output
cs.set_param('InspectSignalLogs', 'off');   % Record logged workspace data in Simulation Data Inspector
cs.set_param('StreamToWorkspace', 'off');   % Write streamed signals to workspace
cs.set_param('LimitDataPoints', 'off');   % Limit data points
cs.set_param('Decimation', '1');   % Decimation
cs.set_param('VisualizeSimOutput', 'on');   % Enable live streaming of selected signals to Simulation Data Inspector

% Optimization
cs.set_param('BlockReduction', 'on');   % Block reduction
cs.set_param('ConditionallyExecuteInputs', 'on');   % Conditional input branch execution
cs.set_param('BooleanDataType', 'on');   % Implement logic signals as Boolean data (vs. double)
cs.set_param('LifeSpan', 'auto');   % Application lifespan (days)
cs.set_param('UseDivisionForNetSlopeComputation', 'off');   % Use division for fixed-point net slope computation
cs.set_param('UseFloatMulNetSlope', 'off');   % Use floating-point multiplication to handle net slope corrections
cs.set_param('DefaultUnderspecifiedDataType', 'double');   % Default for underspecified data type
cs.set_param('InitFltsAndDblsToZero', 'off');   % Use memset to initialize floats and doubles to 0.0
cs.set_param('EfficientFloat2IntCast', 'off');   % Remove code from floating-point to integer conversions that wraps out-of-range values
cs.set_param('EfficientMapNaN2IntZero', 'on');   % Remove code from floating-point to integer conversions with saturation that maps NaN to zero
cs.set_param('SimCompilerOptimization', 'off');   % Compiler optimization level
cs.set_param('AccelVerboseBuild', 'off');   % Verbose accelerator builds
cs.set_param('DefaultParameterBehavior', 'Tunable');   % Default parameter behavior
cs.set_param('OptimizeBlockIOStorage', 'on');   % Signal storage reuse
cs.set_param('LocalBlockOutputs', 'on');   % Enable local block outputs
cs.set_param('ExpressionFolding', 'on');   % Eliminate superfluous local variables (expression folding)
cs.set_param('BufferReuse', 'on');   % Reuse local block outputs
cs.set_param('EnableMemcpy', 'on');   % Use memcpy for vector assignment
cs.set_param('MemcpyThreshold', 64);   % Memcpy threshold (bytes)
cs.set_param('RollThreshold', 5);   % Loop unrolling threshold
cs.set_param('MaxStackSize', 'Inherit from target');   % Maximum stack size (bytes)
cs.set_param('StateBitsets', 'off');   % Use bitsets for storing state configuration
cs.set_param('DataBitsets', 'off');   % Use bitsets for storing Boolean data
cs.set_param('ActiveStateOutputEnumStorageType', 'Native Integer');   % Base storage type for automatically created enumerations
cs.set_param('AdvancedOptControl', '');   % AdvancedOptControl
cs.set_param('BufferReusableBoundary', 'on');   % BufferReusableBoundary

% Diagnostics
cs.set_param('AlgebraicLoopMsg', 'warning');   % Algebraic loop
cs.set_param('ArtificialAlgebraicLoopMsg', 'warning');   % Minimize algebraic loop
cs.set_param('BlockPriorityViolationMsg', 'warning');   % Block priority violation
cs.set_param('MinStepSizeMsg', 'warning');   % Min step size violation
cs.set_param('TimeAdjustmentMsg', 'none');   % Sample hit time adjusting
cs.set_param('MaxConsecutiveZCsMsg', 'error');   % Consecutive zero crossings violation
cs.set_param('UnknownTsInhSupMsg', 'warning');   % Unspecified inheritability of sample time
cs.set_param('ConsistencyChecking', 'none');   % Solver data inconsistency
cs.set_param('SolverPrmCheckMsg', 'none');   % Automatic solver parameter selection
cs.set_param('ModelReferenceExtraNoncontSigs', 'error');   % Extraneous discrete derivative signals
cs.set_param('StateNameClashWarn', 'none');   % State name clash
cs.set_param('SimStateInterfaceChecksumMismatchMsg', 'warning');   % SimState interface checksum mismatch
cs.set_param('SimStateOlderReleaseMsg', 'error');   % SimState object from earlier release
cs.set_param('InheritedTsInSrcMsg', 'warning');   % Source block specifies -1 sample time
cs.set_param('MultiTaskRateTransMsg', 'error');   % Multitask rate transition
cs.set_param('SingleTaskRateTransMsg', 'none');   % Single task rate transition
cs.set_param('MultiTaskCondExecSysMsg', 'error');   % Multitask conditionally executed subsystem
cs.set_param('TasksWithSamePriorityMsg', 'warning');   % Tasks with equal priority
cs.set_param('SigSpecEnsureSampleTimeMsg', 'warning');   % Enforce sample times specified by Signal Specification blocks
cs.set_param('SignalResolutionControl', 'UseLocalSettings');   % Signal resolution
cs.set_param('CheckMatrixSingularityMsg', 'none');   % Division by singular matrix
cs.set_param('IntegerSaturationMsg', 'warning');   % Saturate on overflow
cs.set_param('UnderSpecifiedDataTypeMsg', 'none');   % Underspecified data types
cs.set_param('SignalRangeChecking', 'none');   % Simulation range checking
cs.set_param('IntegerOverflowMsg', 'warning');   % Wrap on overflow
cs.set_param('SignalInfNanChecking', 'none');   % Inf or NaN block output
cs.set_param('RTPrefix', 'error');   % "rt" prefix for identifiers
cs.set_param('ParameterDowncastMsg', 'error');   % Detect downcast
cs.set_param('ParameterOverflowMsg', 'error');   % Detect overflow
cs.set_param('ParameterUnderflowMsg', 'none');   % Detect underflow
cs.set_param('ParameterPrecisionLossMsg', 'warning');   % Detect precision loss
cs.set_param('ParameterTunabilityLossMsg', 'warning');   % Detect loss of tunability
cs.set_param('ReadBeforeWriteMsg', 'UseLocalSettings');   % Detect read before write
cs.set_param('WriteAfterReadMsg', 'UseLocalSettings');   % Detect write after read
cs.set_param('WriteAfterWriteMsg', 'UseLocalSettings');   % Detect write after write
cs.set_param('MultiTaskDSMMsg', 'error');   % Multitask data store
cs.set_param('UniqueDataStoreMsg', 'none');   % Duplicate data store names
cs.set_param('UnderspecifiedInitializationDetection', 'Simplified');   % Underspecified initialization detection
cs.set_param('ArrayBoundsChecking', 'none');   % Array bounds exceeded
cs.set_param('AssertControl', 'UseLocalSettings');   % Model Verification block enabling
cs.set_param('AllowSymbolicDim', 'on');   % Allow symbolic dimension specification
cs.set_param('UnnecessaryDatatypeConvMsg', 'none');   % Unnecessary type conversions
cs.set_param('VectorMatrixConversionMsg', 'none');   % Vector/matrix block input conversion
cs.set_param('Int32ToFloatConvMsg', 'warning');   % 32-bit integer to single precision float conversion
cs.set_param('FixptConstUnderflowMsg', 'none');   % Detect underflow
cs.set_param('FixptConstOverflowMsg', 'none');   % Detect overflow
cs.set_param('FixptConstPrecisionLossMsg', 'none');   % Detect precision loss
cs.set_param('SignalLabelMismatchMsg', 'none');   % Signal label mismatch
cs.set_param('UnconnectedInputMsg', 'warning');   % Unconnected block input ports
cs.set_param('UnconnectedOutputMsg', 'warning');   % Unconnected block output ports
cs.set_param('UnconnectedLineMsg', 'warning');   % Unconnected line
cs.set_param('RootOutportRequireBusObject', 'warning');   % Unspecified bus object at root Outport block
cs.set_param('BusObjectLabelMismatch', 'warning');   % Element name mismatch
cs.set_param('StrictBusMsg', 'ErrorLevel1');   % Mux blocks used to create bus signals; Bus signal treated as vector
cs.set_param('NonBusSignalsTreatedAsBus', 'none');   % Non-bus signals treated as bus signals
cs.set_param('BusNameAdapt', 'WarnAndRepair');   % Repair bus selections
cs.set_param('InvalidFcnCallConnMsg', 'error');   % Invalid function-call connection
cs.set_param('FcnCallInpInsideContextMsg', 'error');   % Context-dependent inputs
cs.set_param('SFcnCompatibilityMsg', 'none');   % S-function upgrades needed
cs.set_param('FrameProcessingCompatibilityMsg', 'error');   % Block behavior depends on frame status of signal
cs.set_param('ModelReferenceVersionMismatchMessage', 'none');   % Model block version mismatch
cs.set_param('ModelReferenceIOMismatchMessage', 'none');   % Port and parameter mismatch
cs.set_param('ModelReferenceIOMsg', 'none');   % Invalid root Inport/Outport block connection
cs.set_param('ModelReferenceDataLoggingMessage', 'warning');   % Unsupported data logging
cs.set_param('SaveWithDisabledLinksMsg', 'warning');   % Block diagram contains disabled library links
cs.set_param('SaveWithParameterizedLinksMsg', 'warning');   % Block diagram contains parameterized library links
cs.set_param('SFUnusedDataAndEventsDiag', 'warning');   % Unused data, events, messages and functions
cs.set_param('SFUnexpectedBacktrackingDiag', 'error');   % Unexpected backtracking
cs.set_param('SFInvalidInputDataAccessInChartInitDiag', 'warning');   % Invalid input data access in chart initialization
cs.set_param('SFNoUnconditionalDefaultTransitionDiag', 'error');   % No unconditional default transitions
cs.set_param('SFTransitionOutsideNaturalParentDiag', 'warning');   % Transition outside natural parent
cs.set_param('SFUnreachableExecutionPathDiag', 'warning');   % Unreachable execution path
cs.set_param('SFUndirectedBroadcastEventsDiag', 'warning');   % Undirected event broadcasts
cs.set_param('SFTransitionActionBeforeConditionDiag', 'warning');   % Transition action specified before condition action
cs.set_param('SFOutputUsedAsStateInMooreChartDiag', 'error');   % Read-before-write to output in Moore chart
cs.set_param('SFTemporalDelaySmallerThanSampleTimeDiag', 'warning');   % Absolute time temporal value shorter than sampling period
cs.set_param('SFSelfTransitionDiag', 'warning');   % Self-transition on leaf state
cs.set_param('SFExecutionAtInitializationDiag', 'warning');   % 'Execute-at-initialization' disabled in presence of input events
cs.set_param('SFMachineParentedDataDiag', 'warning');   % Use of machine-parented data instead of Data Store Memory
cs.set_param('IgnoredZcDiagnostic', 'warning');   % IgnoredZcDiagnostic
cs.set_param('InitInArrayFormatMsg', 'warning');   % InitInArrayFormatMsg
cs.set_param('MaskedZcDiagnostic', 'warning');   % MaskedZcDiagnostic
cs.set_param('ModelReferenceSymbolNameMessage', 'warning');   % ModelReferenceSymbolNameMessage
cs.set_param('AllowedUnitSystems', 'all');   % Allowed unit systems
cs.set_param('UnitsInconsistencyMsg', 'warning');   % Units inconsistency messages
cs.set_param('AllowAutomaticUnitConversions', 'on');   % Allow automatic unit conversions

% Hardware Implementation
cs.set_param('ProdHWDeviceType', 'Intel->x86-64 (Windows64)');   % Production device vendor and type
cs.set_param('ProdLongLongMode', 'off');   % Support long long in production hardware
cs.set_param('ProdEqTarget', 'on');   % Test hardware is the same as production hardware
cs.set_param('TargetPreprocMaxBitsSint', 32);   % TargetPreprocMaxBitsSint
cs.set_param('TargetPreprocMaxBitsUint', 32);   % TargetPreprocMaxBitsUint

% Model Referencing
cs.set_param('UpdateModelReferenceTargets', 'IfOutOfDateOrStructuralChange');   % Rebuild
cs.set_param('EnableParallelModelReferenceBuilds', 'off');   % Enable parallel model reference builds
cs.set_param('ModelReferenceNumInstancesAllowed', 'Multi');   % Total number of instances allowed per top model
cs.set_param('PropagateVarSize', 'Infer from blocks in model');   % Propagate sizes of variable-size signals
cs.set_param('ModelReferenceMinAlgLoopOccurrences', 'off');   % Minimize algebraic loop occurrences
cs.set_param('EnableRefExpFcnMdlSchedulingChecks', 'on');   % Enable strict scheduling checks for referenced export-function models
cs.set_param('PropagateSignalLabelsOutOfModel', 'on');   % Propagate all signal labels out of the model
cs.set_param('ModelReferencePassRootInputsByReference', 'on');   % Pass fixed-size scalar root inputs by value for code generation
cs.set_param('ModelDependencies', '');   % Model dependencies
cs.set_param('ParallelModelReferenceErrorOnInvalidPool', 'on');   % ParallelModelReferenceErrorOnInvalidPool
cs.set_param('SupportModelReferenceSimTargetCustomCode', 'off');   % SupportModelReferenceSimTargetCustomCode

% Simulation Target
cs.set_param('CompileTimeRecursionLimit', 50);   % Compile-time recursion limit for MATLAB functions
cs.set_param('EnableRuntimeRecursion', 'on');   % Enable run-time recursion for MATLAB functions
cs.set_param('SFSimEcho', 'on');   % Echo expressions without semicolons
cs.set_param('SimCtrlC', 'on');   % Ensure responsiveness
cs.set_param('SimIntegrity', 'on');   % Ensure memory integrity
cs.set_param('SimGenImportedTypeDefs', 'off');   % Generate typedefs for imported bus and enumeration types
cs.set_param('SimBuildMode', 'sf_incremental_build');   % Simulation target build mode
cs.set_param('SimReservedNameArray', []);   % Reserved names
cs.set_param('SimParseCustomCode', 'on');   % Parse custom code symbols
cs.set_param('SimCustomSourceCode', '');   % Source file
cs.set_param('SimCustomHeaderCode', '');   % Header file
cs.set_param('SimCustomInitializer', '');   % Initialize function
cs.set_param('SimCustomTerminator', '');   % Terminate function
cs.set_param('SimUserIncludeDirs', '');   % Include directories
cs.set_param('SimUserSources', '');   % Source files
cs.set_param('SimUserLibraries', '');   % Libraries
cs.set_param('SimUserDefines', '');   % Defines
cs.set_param('SFSimEnableDebug', 'off');   % Allow setting breakpoints during simulation

% Code Generation
cs.set_param('HardwareBoard', 'None');   % Hardware board
cs.set_param('TargetLang', 'C');   % Language
cs.set_param('Toolchain', 'Automatically locate an installed toolchain');   % Toolchain
cs.set_param('BuildConfiguration', 'Faster Builds');   % Build configuration
cs.set_param('ObjectivePriorities', []);   % Prioritized objectives
cs.set_param('CheckMdlBeforeBuild', 'Off');   % Check model before generating code
cs.set_param('GenCodeOnly', 'off');   % Generate code only
cs.set_param('PackageGeneratedCodeAndArtifacts', 'off');   % Package code and artifacts
cs.set_param('RTWVerbose', 'on');   % Verbose build
cs.set_param('RetainRTWFile', 'off');   % Retain .rtw file
cs.set_param('ProfileTLC', 'off');   % Profile TLC
cs.set_param('TLCDebug', 'off');   % Start TLC debugger when generating code
cs.set_param('TLCCoverage', 'off');   % Start TLC coverage when generating code
cs.set_param('TLCAssert', 'off');   % Enable TLC assertion
cs.set_param('RTWUseSimCustomCode', 'off');   % Use the same custom code settings as Simulation Target
cs.set_param('CustomSourceCode', '');   % Source file
cs.set_param('CustomHeaderCode', '');   % Header file
cs.set_param('CustomInclude', '');   % Include directories
cs.set_param('CustomSource', '');   % Source files
cs.set_param('CustomLibrary', '');   % Libraries
cs.set_param('CustomLAPACKCallback', '');   % Custom LAPACK library callback
cs.set_param('CustomDefine', '');   % Defines
cs.set_param('CustomInitializer', '');   % Initialize function
cs.set_param('CustomTerminator', '');   % Terminate function
cs.set_param('PostCodeGenCommand', '');   % Post code generation command
cs.set_param('CompOptLevelCompliant', 'on');   % CompOptLevelCompliant
cs.set_param('SaveLog', 'off');   % Save build log
cs.set_param('TLCOptions', '');   % TLC command line options
cs.set_param('GenerateReport', 'off');   % Create code generation report
cs.set_param('GenerateComments', 'on');   % Include comments
cs.set_param('SimulinkBlockComments', 'on');   % Simulink block / Stateflow object comments
cs.set_param('MATLABSourceComments', 'off');   % MATLAB source code as comments
cs.set_param('ShowEliminatedStatement', 'off');   % Show eliminated blocks
cs.set_param('ForceParamTrailComments', 'off');   % Verbose comments for SimulinkGlobal storage class
cs.set_param('MaxIdLength', 31);   % Maximum identifier length
cs.set_param('UseSimReservedNames', 'off');   % Use the same reserved names as Simulation Target
cs.set_param('ReservedNameArray', []);   % Reserved names
cs.set_param('IncAutoGenComments', 'off');   % IncAutoGenComments
cs.set_param('IncDataTypeInIds', 'off');   % IncDataTypeInIds
cs.set_param('IncHierarchyInIds', 'off');   % IncHierarchyInIds
cs.set_param('PreserveName', 'off');   % PreserveName
cs.set_param('PreserveNameWithParent', 'off');   % PreserveNameWithParent
cs.set_param('TargetLangStandard', 'C99 (ISO)');   % Standard math library
cs.set_param('CodeReplacementLibrary', 'None');   % Code replacement library
cs.set_param('UtilityFuncGeneration', 'Auto');   % Shared code placement
cs.set_param('CodeInterfacePackaging', 'Nonreusable function');   % Code interface packaging
cs.set_param('GRTInterface', 'off');   % Classic call interface
cs.set_param('SupportNonFinite', 'on');   % Support non-finite numbers
cs.set_param('CombineOutputUpdateFcns', 'on');   % Single output/update function
cs.set_param('MatFileLogging', 'on');   % MAT-file logging
cs.set_param('LogVarNameModifier', 'rt_');   % MAT-file variable name modifier
cs.set_param('CPPClassGenCompliant', 'on');   % CPPClassGenCompliant
cs.set_param('ConcurrentExecutionCompliant', 'on');   % ConcurrentExecutionCompliant
cs.set_param('ERTFirstTimeCompliant', 'off');   % ERTFirstTimeCompliant
cs.set_param('GenerateFullHeader', 'on');   % GenerateFullHeader
cs.set_param('InferredTypesCompatibility', 'off');   % InferredTypesCompatibility
cs.set_param('ModelReferenceCompliant', 'on');   % ModelReferenceCompliant
cs.set_param('MultiwordLength', 2048);   % MultiwordLength
cs.set_param('ParMdlRefBuildCompliant', 'on');   % ParMdlRefBuildCompliant
cs.set_param('TargetFcnLib', 'ansi_tfl_table_tmw.mat');   % TargetFcnLib
cs.set_param('TargetLibSuffix', '');   % TargetLibSuffix
cs.set_param('TargetPreCompLibLocation', '');   % TargetPreCompLibLocation
cs.set_param('UseToolchainInfoCompliant', 'on');   % UseToolchainInfoCompliant
cs.set_param('ExtMode', 'off');   % External mode
cs.set_param('RTWCAPIParams', 'off');   % Generate C API for parameters
cs.set_param('RTWCAPIRootIO', 'off');   % Generate C API for root-level I/O
cs.set_param('RTWCAPISignals', 'off');   % Generate C API for signals
cs.set_param('RTWCAPIStates', 'off');   % Generate C API for states
cs.set_param('GenerateASAP2', 'off');   % ASAP2 interface

% Simulink Coverage
cs.set_param('CovModelRefEnable', 'off');   % Record coverage for referenced models
cs.set_param('RecordCoverage', 'off');   % Record coverage for this model
cs.set_param('CovScope', 'EntireSystem');   % Scope of coverage analysis
cs.set_param('CovEnable', 'off');   % Enable coverage analysis
cs.set_param('CovExternalEMLEnable', 'on');   % Record coverage for MATLAB files
cs.set_param('CovHighlightResults', 'off');   % Display coverage results using model coloring
cs.set_param('CovUnsupportedBlockWarning', 'on');   % Warn when unsupported blocks exist in model
cs.set_param('CovLogicBlockShortCircuit', 'off');   % Treat Simulink logic blocks as short-circuited
cs.set_param('CovMetricRelationalBoundary', 'off');   % Enable relational boundary metric
cs.set_param('CovMetricSaturateOnIntegerOverflow', 'off');   % Enable saturation on integer overflow metric
cs.set_param('CovMetricObjectiveConstraint', 'off');   % Enable objectives and constraints metric
cs.set_param('CovMetricSignalSize', 'off');   % Enable signal size metric
cs.set_param('CovMetricSignalRange', 'off');   % Enable signal range metric
cs.set_param('CovMetricLookupTable', 'off');   % Enable lookup table metric
cs.set_param('CovMetricStructuralLevel', 'Decision');   % Structural coverage level
cs.set_param('CovMetricSettings', 'dwe');   % Coverage metric settings
cs.set_param('CovEnableCumulative', 'on');   % Enable cumulative data collection
cs.set_param('CovSaveCumulativeToWorkspaceVar', 'off');   % Save cumulative coverage results in workspace variable
cs.set_param('CovSaveSingleToWorkspaceVar', 'off');   % Save last coverage run in workspace variable
cs.set_param('CovReportOnPause', 'on');   % Update coverage results on pause
cs.set_param('CovHtmlReporting', 'off');   % Generate coverage report
cs.set_param('CovForceBlockReductionOff', 'on');   % Force block reduction off
cs.set_param('CovUseTimeInterval', 'off');   % Restrict coverage recording interval
cs.set_param('CovFilter', '');   % Coverage filter filename
cs.set_param('CovShowResultsExplorer', 'on');   % Show Results Explorer
cs.set_param('CovOutputDir', 'slcov_output/$ModelName$');   % Output directory
cs.set_param('CovSaveOutputData', 'on');   % Save output data
cs.set_param('CovDataFileName', '$ModelName$_cvdata');   % Data file name

% HDL Coder
try 
	cs_componentCC = hdlcoderui.hdlcc;
	cs_componentCC.createCLI();
	cs.attachComponent(cs_componentCC);
catch ME
	warning('Simulink:ConfigSet:AttachComponentError', ME.message);
end
end