var modelType = "Integrex i-100S";
description = "Mazak Integrex i-100S";
// >>>>> INCLUDED FROM ../common/mazak integrex i.cps
//Save This line for editing purposes, comment out before merge
//var modelType = "Integrex i-200S";

/**
  Copyright (C) 2012-2022 by Autodesk, Inc.
  All rights reserved.

  Mazak Integrex post processor configuration.

  $Revision: 44083 1c5ad993a086f043365c6f9038d5d6561bad0ddd $
  $Date: 2023-08-12 05:06:32 $

  FORKID {62F61C65-979D-4f9f-97B0-C5F9634CC6A7}
*/

///////////////////////////////////////////////////////////////////////////////
//                        MANUAL NC COMMANDS
//
// The following ACTION commands are supported by this post.
//
//     useXZCMode                 - Force XZC mode for next operation
//     usePolarMode               - Force Polar mode for next operation
//     useSmoothing               - Use Smoothing for next operation
//
///////////////////////////////////////////////////////////////////////////////

if (!description) {
  description = "Mazak Integrex I";
}

vendor = "Mazak";
vendorUrl = "https://www.mazak.com";
legal = "Copyright (C) 2012-2022 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 45702;

if (!longDescription) {
  longDescription = subst("Preconfigured %1 post (Smooth/Matrix) with support for mill-turn. Enter the Tool ID Code in the Product ID of the Tool. Leave Blank if not used", description);
}

extension = "eia";
programNameIsInteger = false;
setCodePage("ascii");

capabilities = CAPABILITY_MILLING | CAPABILITY_TURNING;
tolerance = spatial(0.002, MM);

minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
maximumCircularSweep = toRad(180);
allowHelicalMoves = true;
allowedCircularPlanes = undefined; // allow any circular motion
allowSpiralMoves = false;
highFeedrate = (unit == IN) ? 400 : 5000;

// user-defined properties
properties = {
  controllerType: {
    title      : "Controller model",
    description: "Select the controller model",
    group      : "configuration",
    type       : "enum",
    values     : [
      "Matrix",
      "Smooth"
    ],
    value: "Smooth",
    scope: "post"
  },
  tiltedPlaneMethod: {
    title      : "Select tilted plane mode",
    description: "Select either G68 or G68.2 for tilted plane mode",
    group      : "multiAxis",
    type       : "enum",
    values     : [
      "G68",
      "G68.2"
    ],
    value: "G68",
    scope: "post"
  },
  useG0Polar: {
    title      : "Use G0 for Polar",
    description: "Disable to use G1 for rapid moves when G12.1 Polar Interpolation is active.",
    group      : "preferences",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  useG61: {
    title      : "Use G61.1 Geometry compensation",
    description: "Output G61.1 geometry compensation when milling.",
    group      : "preferences",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  writeMachine: {
    title      : "Write machine",
    description: "Output the machine settings in the header of the code.",
    group      : "formats",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  writeTools: {
    title      : "Write tool list",
    description: "Output a tool list in the header of the code.",
    group      : "formats",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  writeDateAndTime: {
    title      : "Write date and time",
    description: "Output date and time in the header of the code.",
    group      : "formats",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  useTCPC: {
    title      : "Use TCPC programming",
    description: "The control supports Tool Center Point Control programming.",
    group      : "multiAxis",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  preloadTool: {
    title      : "Preload tool",
    description: "Preloads the next tool at a tool change (if any).",
    group      : "preferences",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  showSequenceNumbers: {
    title      : "Use sequence numbers",
    description: "'Yes' outputs sequence numbers on each block, 'Only on tool change' outputs sequence numbers on tool change blocks only, and 'No' disables the output of sequence numbers.",
    group      : "formats",
    type       : "enum",
    values     : [
      {title:"Yes", id:"true"},
      {title:"No", id:"false"},
      {title:"Only on tool change", id:"toolChange"}
    ],
    value: "toolChange",
    scope: "post"
  },
  sequenceNumberStart: {
    title      : "Start sequence number",
    description: "The number at which to start the sequence numbers.",
    group      : "formats",
    type       : "integer",
    value      : 10,
    scope      : "post"
  },
  sequenceNumberIncrement: {
    title      : "Sequence number increment",
    description: "The amount by which the sequence number is incremented by in each block.",
    group      : "formats",
    type       : "integer",
    value      : 10,
    scope      : "post"
  },
  optionalStop: {
    title      : "Optional stop",
    description: "Outputs optional stop code during when necessary in the code.",
    group      : "preferences",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  separateWordsWithSpace: {
    title      : "Separate words with space",
    description: "Adds spaces between words if 'yes' is selected.",
    group      : "formats",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  useRadius: {
    title      : "Radius arcs",
    description: "If yes is selected, arcs are outputted using radius values rather than IJK.",
    group      : "preferences",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  maximumSpindleSpeed: {
    title      : "Max spindle speed",
    description: "Defines the maximum spindle speed allowed by your machines.",
    group      : "configuration",
    type       : "integer",
    range      : [0, 999999999],
    value      : 3300,
    scope      : "post"
  },
  useParametricFeed: {
    title      : "Parametric feed",
    description: "Specifies the feed value that should be output using a Q value.",
    group      : "preferences",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  showNotes: {
    title      : "Show notes",
    description: "Writes operation notes as comments in the outputted code.",
    group      : "formats",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  useCycles: {
    title      : "Use cycles",
    description: "Specifies if canned drilling cycles should be used.",
    group      : "preferences",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  usePartCatcher: {
    title      : "Use part catcher",
    description: "Specifies whether part catcher code should be output.",
    group      : "configuration",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  useTailStock: {
    title      : "Use tailstock",
    description: "Specifies whether to use the tailstock or not.",
    group      : "configuration",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  transferTool: {
    title      : "Transfer Tool Number",
    description: "Defines the tool called when secondary spindle chuck process happens",
    group      : "preferences",
    type       : "integer",
    range      : [0, 999999999],
    value      : 41,
    scope      : "post"
  },
  transferUseTorque: {
    title      : "Stock-transfer torque control",
    description: "Use torque control for stock transfer.",
    group      : "preferences",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  homePositionZ: {
    title      : "G53 home position Z",
    description: "G53 Z-axis home position.",
    group      : "homePositions",
    type       : "number",
    value      : 0,
    scope      : "post"
  },
  homePositionSubZ: {
    title      : "G53 home position Z (secondary spindle)",
    description: "G53 Z-axis home position for the secondary spindle.",
    group      : "homePositions",
    type       : "number",
    value      : 0,
    scope      : "post"
  },
  writeVersion: {
    title      : "Write version",
    description: "Write the version number in the header of the code.",
    group      : "formats",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  useRigidTapping: {
    title      : "Use rigid tapping",
    description: "Select 'Yes' to enable, 'No' to disable.",
    group      : "preferences",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  useSimpleThread: {
    title      : "Use simple threading cycle",
    description: "Enable to output G292 simple threading cycle, disable to output G276 standard threading cycle.",
    group      : "preferences",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  useYAxisForDrilling: {
    title      : "Position in Y for axial drilling",
    description: "Positions in Y for axial drilling options when it can instead of using the C-axis.",
    group      : "preferences",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  useFixedOffset: {
    title      : "Use G43 H#3020",
    description: "Select 'Yes' to use G43 H#3020, 'No' to use the tool offset number.",
    group      : "multiAxis",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  tableAdjust: {
    title      : "Adjust points for table",
    description: "Set to Yes if table coordinate system is used (F85 Bit 2 is set to 0). Set to No if the workpiece coordinate system is used (F85 Bit 2 is set to 1).",
    type       : "boolean",
    group      : "preferences",
    value      : true,
    scope      : "post"
  },
};

// wcs definiton
wcsDefinitions = {
  useZeroOffset: false,
  wcs          : [
    {name:"Standard", format:"G", range:[54, 59]},
    {name:"Extended", format:"G54.1 P", range:[1, 48]}
  ]
};

var singleLineCoolant = false; // specifies to output multiple coolant codes in one line rather than in separate lines
// samples:
// {id: COOLANT_THROUGH_TOOL, on: 88, off: 89}
// {id: COOLANT_THROUGH_TOOL, on: [8, 88], off: [9, 89]}
// {id: COOLANT_THROUGH_TOOL, turret1:{on: [8, 88], off:[9, 89]}, turret2:{on:88, off:89}}
// {id: COOLANT_THROUGH_TOOL, spindle1:{on: [8, 88], off:[9, 89]}, spindle2:{on:88, off:89}}
// {id: COOLANT_THROUGH_TOOL, spindle1t1:{on: [8, 88], off:[9, 89]}, spindle1t2:{on:88, off:89}}
// {id: COOLANT_THROUGH_TOOL, on: "M88 P3 (myComment)", off: "M89"}
var coolants = [
  {id:COOLANT_FLOOD, on:8, off:9},
  {id:COOLANT_MIST},
  {id:COOLANT_THROUGH_TOOL, on:51, off:163},
  {id:COOLANT_AIR, on:129, off:9},
  {id:COOLANT_AIR_THROUGH_TOOL, turret1:{on:132, off:9}, turret2:{}},
  {id:COOLANT_SUCTION},
  {id:COOLANT_FLOOD_MIST},
  {id:COOLANT_FLOOD_THROUGH_TOOL, on: [8, 51], off: [9, 163]},
  {id:COOLANT_OFF, off:9}
];

var writeDebug = false; // specifies to output debug information

var permittedCommentChars = " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,=_-";

var gFormat = createFormat({prefix:"G", decimals:1});
var mFormat = createFormat({prefix:"M", decimals:0});

var spatialFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var xFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true, scale:2}); // diameter mode & IS SCALING POLAR COORDINATES
var yFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var zFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var subZFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true, forceSign:true});
var rFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true}); // radius
var abcFormat = createFormat({decimals:3, forceDecimal:true, scale:DEG});
var cFormat = createFormat({decimals:3, forceDecimal:true, scale:DEG});
var feedFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var pitchFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var rpmFormat = createFormat({decimals:0});
var milliFormat = createFormat({decimals:0}); // milliseconds // range 1-99999999
var taperFormat = createFormat({decimals:1, scale:DEG});
var threadP1Format = createFormat({decimals:0, forceDecimal:false, trim:false, width:6, zeropad:true});
var threadPQFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});

var xOutput = createVariable({onchange:function () {retracted = false;}, prefix:"X"}, xFormat);
var yOutput = createVariable({prefix:"Y"}, yFormat);
var zOutput = createVariable({onchange:function () {retracted = false;}, prefix:"Z"}, zFormat);
var subWOutput = createVariable({prefix:"W[#501", force:true}, subZFormat);
var aOutput = createVariable({prefix:"A"}, abcFormat);
var bOutput = createVariable({prefix:"B"}, abcFormat);
var cOutput = createVariable({prefix:"C"}, cFormat);
var uOutput = createVariable({prefix:"U", force:true}, cFormat);
var barOutput = createVariable({prefix:"W", force:true}, spatialFormat);
var feedOutput = createVariable({prefix:"F"}, feedFormat);
var pitchOutput = createVariable({prefix:"F", force:true}, pitchFormat);
var sOutput = createVariable({prefix:"S", force:true}, rpmFormat);

var threadP1Output = createVariable({prefix:"P", force:true}, threadP1Format);
var threadP2Output = createVariable({prefix:"P", force:true}, threadPQFormat);
var threadQOutput = createVariable({prefix:"Q", force:true}, threadPQFormat);
var threadROutput = createVariable({prefix:"R", force:true}, threadPQFormat);
var g92ROutput = createVariable({prefix:"R"}, zFormat); // no scaling

// circular output
var iOutput = createReferenceVariable({prefix:"I"}, spatialFormat); // no scaling
var jOutput = createReferenceVariable({prefix:"J"}, spatialFormat);
var kOutput = createReferenceVariable({prefix:"K"}, spatialFormat);

var gMotionModal = createModal({}, gFormat); // modal group 1 // G0-G3, ...
var gRotationModal = createModal({}, gFormat); // G68-G69
var gPlaneModal = createModal({onchange:function () {gMotionModal.reset();}}, gFormat); // modal group 2 // G17-19
var gFeedModeModal = createModal({}, gFormat);
var gSpindleModeModal = createModal({}, gFormat); // modal group 5 // G96-97
var gUnitModal = createModal({}, gFormat); // modal group 6 // G20-21
var gPolarModal = createModal({}, gFormat); // G12.1, G13.1
var gCycleModal = gMotionModal;
var gAbsIncModal = createModal({}, gFormat); // modal group 3 // G90-91
var gRetractModal = createModal({force:true}, gFormat); // modal group 10 // G98-99
var gSpindleModal = createModal({}, gFormat);
var gSelectSpindleModal = createModal({}, mFormat);
var cAxisEngageModal = createModal({}, mFormat);

// fixed settings
var firstFeedParameter = 105;
//var xHomeParameter = 903;
var zHomeParameter = 901;
//var yHomeParameter = 904;
var zSubHomeParameter = 902;
var gotYAxis = true;

var yAxisMinimum; // specifies the minimum range for the Y-axis
var yAxisMaximum; // specifies the maximum range for the Y-axis
var xAxisMinimum; // specifies the maximum range for the X-axis (RADIUS MODE VALUE)

var gotPolarInterpolation = true; // specifies if the machine has XY polar interpolation (G112) capabilities
var maximumSpindleSpeedLive;
var gotBAxis = true;
var useMultiAxisFeatures;
var gotSecondarySpindle;
var gotMultiTurret; // specifies if the machine has several turrets
//Lower Turret is untested at this time
var airCleanChuck = false; // use air to clean off chuck at part transfer

var WARNING_WORK_OFFSET = 0;
var SPINDLE_MAIN = 0;
var SPINDLE_SUB = 1;
var SPINDLE_LIVE = 2;

var TRANSFER_PHASE = 0;
var TRANSFER_STOP = 2;

// getSpindle parameters
var TOOL = false;
var PART = true;

// collected state
var sequenceNumber;
var showSequenceNumbers;
var currentWorkOffset;
var optionalSection = false;
var forceSpindleSpeed = false;
var activeMovements; // do not use by default
var currentFeedId;
var previousSpindle = SPINDLE_MAIN;
var previousPartSpindle = SPINDLE_MAIN;
var activeSpindle = SPINDLE_MAIN;
var partCutoff = false;
var transferUseTorque;
var forcePolarMode = false; // force Polar output, activated by Action:usePolarMode
var forceXZCMode = false; // forces XZC output, activated by Action:useXZCMode
var useSmoothing = false;
var maximumCircularRadiiDifference = toPreciseUnit(0.005, MM);
var bestABCIndex = undefined;
var reverseAxes;
var lastSpindleMode = undefined;
var lastSpindleSpeed = 0;
var lastSpindleDirection = undefined;
var retracted = false; // specifies that the tool has been retracted to the safe plane
var g68Rotation = undefined;
var useTCPC;
var previousBAxisOrientationTurning = new Vector(0, 0, 0);

var machineState = {
  liveToolIsActive        : undefined,
  cAxisIsEngaged          : undefined,
  machiningDirection      : undefined,
  mainSpindleIsActive     : undefined,
  subSpindleIsActive      : undefined,
  mainSpindleBrakeIsActive: undefined,
  subSpindleBrakeIsActive : undefined,
  tailstockIsActive       : undefined,
  usePolarMode            : undefined,
  useXZCMode              : undefined,
  axialCenterDrilling     : undefined,
  tapping                 : undefined,
  feedPerRevolution       : undefined,
  bAxisOrientationTurning : new Vector(0, 0, 0),
  spindlesAreAttached     : false,
  stockTransferIsActive   : false,
  currentTurret           : 1
};

/** G/M codes setup. */
function getCode(code) {
  switch (code) {
  case "PART_CATCHER_ON":
    return mFormat.format(248);
  case "PART_CATCHER_OFF":
    return mFormat.format(249);
  case "TAILSTOCK_ON":
    machineState.tailstockIsActive = true;
    return mFormat.format(841);
  case "TAILSTOCK_OFF":
    machineState.tailstockIsActive = false;
    return mFormat.format(843);
  case "ENABLE_C_AXIS":
    machineState.cAxisIsEngaged = true;
    if (currentSection.spindle == SPINDLE_PRIMARY) {
      return cAxisEngageModal.format(200);
    } else {
      return cAxisEngageModal.format(300);
    }
  case "DISABLE_C_AXIS":
    machineState.cAxisIsEngaged = false;
    if (currentSection.spindle == SPINDLE_PRIMARY) {
      return cAxisEngageModal.format(202);
    } else {
      return cAxisEngageModal.format(302);
    }
  case "POLAR_INTERPOLATION_ON":
    if (currentSection.spindle == SPINDLE_PRIMARY) {
      return gPolarModal.format(12.1);
    } else {
      return gPolarModal.format(12.1) + " P2";
    }
  case "POLAR_INTERPOLATION_OFF":
    return gPolarModal.format(13.1);
  case "STOP_LIVE_TOOL":
    machineState.liveToolIsActive = false;
    return mFormat.format(5);
  case "STOP_MAIN_SPINDLE":
    machineState.mainSpindleIsActive = false;
    return mFormat.format(205);
  case "STOP_SUB_SPINDLE":
    machineState.subSpindleIsActive = false;
    return mFormat.format(305);
  case "START_LIVE_TOOL_CW":
    machineState.liveToolIsActive = true;
    return mFormat.format(3);
  case "START_LIVE_TOOL_CCW":
    machineState.liveToolIsActive = true;
    return mFormat.format(4);
  case "START_MAIN_SPINDLE_CW":
    machineState.mainSpindleIsActive = true;
    return mFormat.format(203);
  case "START_MAIN_SPINDLE_CCW":
    machineState.mainSpindleIsActive = true;
    return mFormat.format(204);
  case "START_SUB_SPINDLE_CW":
    machineState.subSpindleIsActive = true;
    return mFormat.format(303);
  case "START_SUB_SPINDLE_CCW":
    machineState.subSpindleIsActive = true;
    return mFormat.format(304);
  case "MAIN_SPINDLE_BRAKE_ON":
    machineState.mainSpindleBrakeIsActive = true;
    return cAxisBrakeModal.format(14);
  case "MAIN_SPINDLE_BRAKE_OFF":
    machineState.mainSpindleBrakeIsActive = false;
    return cAxisBrakeModal.format(15);
  case "SUB_SPINDLE_BRAKE_ON":
    machineState.subSpindleBrakeIsActive = true;
    return cAxisBrakeModal.format(114);
  case "SUB_SPINDLE_BRAKE_OFF":
    machineState.subSpindleBrakeIsActive = false;
    return cAxisBrakeModal.format(115);
  case "FEED_MODE_UNIT_REV":
    machineState.feedPerRevolution = true;
    return gFeedModeModal.format(95);
  case "FEED_MODE_UNIT_MIN":
    machineState.feedPerRevolution = false;
    return gFeedModeModal.format(94);
  case "CONSTANT_SURFACE_SPEED_ON":
    return gSpindleModeModal.format(96);
  case "CONSTANT_SURFACE_SPEED_OFF":
    return gSpindleModeModal.format(97);
  case "CLAMP_B_AXIS":
    return mFormat.format(107);
  case "UNCLAMP_B_AXIS":
    return mFormat.format(108);
  case "CLAMP_PRIMARY_SPINDLE":
    return mFormat.format(210);
  case "UNCLAMP_PRIMARY_SPINDLE":
    return mFormat.format(212);
  case "CLAMP_SECONDARY_SPINDLE":
    return mFormat.format(310);
  case "UNCLAMP_SECONDARY_SPINDLE":
    return mFormat.format(312);
  case "CLAMP_CHUCK":
    return mFormat.format(207);
  case "UNCLAMP_CHUCK":
    return mFormat.format(206);
  case "CLAMP_SECONDARY_CHUCK":
    return mFormat.format(307);
  case "UNCLAMP_SECONDARY_CHUCK":
    return mFormat.format(306);
  case "SPINDLE_SYNCHRONIZATION_PHASE":
    return mFormat.format(511);
  case "SPINDLE_SYNCHRONIZATION_PHASE_OFF":
    return mFormat.format(513);
  case "SPINDLE_SYNCHRONIZATION_SPEED":
    return mFormat.format(511);
  case "SPINDLE_SYNCHRONIZATION_SPEED_OFF":
    return mFormat.format(513);
  case "TORQUE_SKIP_ON":
    return mFormat.format(508);
  case "TORQUE_SKIP_OFF":
    return mFormat.format(509);
  // case "START_CHIP_TRANSPORT":
    // return mFormat.format(undefined);
  // case "STOP_CHIP_TRANSPORT":
    // return mFormat.format(undefined);
  // case "OPEN_DOOR":
    // return mFormat.format(undefined);
  // case "CLOSE_DOOR":
    // return mFormat.format(undefined);
  // case "MAINSPINDLE_AIR_BLAST_ON":
    // return mFormat.format(undefined);
  // case "MAINSPINDLE_AIR_BLAST_OFF":
    // return mFormat.format(undefined);
  // case "SUBSPINDLE_AIR_BLAST_ON":
    // return mFormat.format(undefined);
  // case "SUBSPINDLE_AIR_BLAST_OFF":
    // return mFormat.format(undefined);
  case "AIR_BLAST_ON":
    return 129;
  case "AIR_BLAST_OFF":
    return 9;
  default:
    error(localize("Command " + code + " is not defined."));
    return 0;
  }
}

function isSpindleSpeedDifferent() {
  var areDifferent = false;
  if (isFirstSection()) {
    areDifferent = true;
  }
  if (lastSpindleDirection != tool.clockwise) {
    areDifferent = true;
  }
  if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    var _spindleSpeed = tool.surfaceSpeed * ((unit == MM) ? 1 / 1000.0 : 1 / 12.0);
    if ((lastSpindleMode != SPINDLE_CONSTANT_SURFACE_SPEED) ||
        rpmFormat.areDifferent(lastSpindleSpeed, _spindleSpeed)) {
      areDifferent = true;
    }
  } else {
    if ((lastSpindleMode != SPINDLE_CONSTANT_SPINDLE_SPEED) ||
        rpmFormat.areDifferent(lastSpindleSpeed, spindleSpeed)) {
      areDifferent = true;
    }
  }
  return areDifferent;
}

function onSpindleSpeed(spindleSpeed) {
  if (rpmFormat.areDifferent(spindleSpeed, sOutput.getCurrent())) {
    startSpindle(false, getFramePosition(currentSection.getInitialPosition()), spindleSpeed);
  }
}

function startSpindle(forceRPMMode, initialPosition, rpm) {
  var useConstantSurfaceSpeed = currentSection.getTool().getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED;
  var maximumSpindleSpeed = (tool.maximumSpindleSpeed > 0) ? Math.min(tool.maximumSpindleSpeed, getProperty("maximumSpindleSpeed")) : getProperty("maximumSpindleSpeed");
  var _spindleSpeed = spindleSpeed;
  if (rpm !== undefined) {
    _spindleSpeed = rpm;
  }

  gSpindleModeModal.reset();
  var spindleMode;
  if (useConstantSurfaceSpeed && !forceRPMMode) {
    spindleMode = getCode("CONSTANT_SURFACE_SPEED_ON");
  } else {
    spindleMode = getCode("CONSTANT_SURFACE_SPEED_OFF");
  }

  _spindleSpeed = useConstantSurfaceSpeed ? tool.surfaceSpeed * ((unit == MM) ? 1 / 1000.0 : 1 / 12.0) : _spindleSpeed;
  if (useConstantSurfaceSpeed && forceRPMMode) { // RPM mode is forced until move to initial position
    if (xFormat.getResultingValue(initialPosition.x) == 0) {
      _spindleSpeed = maximumSpindleSpeed;
    } else {
      _spindleSpeed = Math.min((_spindleSpeed * ((unit == MM) ? 1000.0 : 12.0) / (Math.PI * Math.abs(initialPosition.x * 2))), maximumSpindleSpeed);
    }
  }
  switch (currentSection.spindle) {
  case SPINDLE_PRIMARY: // main spindle
    if (machineState.isTurningOperation || machineState.axialCenterDrilling) {
      gSpindleModeModal.reset();
      sOutput.reset();
      if (useConstantSurfaceSpeed && !forceRPMMode) {
        writeBlock(gFormat.format(92), sOutput.format(maximumSpindleSpeed), "R1"); // spindle 1 is the default;
      }
      writeBlock(
        spindleMode,
        sOutput.format(_spindleSpeed),
        tool.clockwise ? getCode("START_MAIN_SPINDLE_CW") : getCode("START_MAIN_SPINDLE_CCW")
      ); // R1 is the default
      sOutput.reset();
    } else {
      writeBlock(getCode("CONSTANT_SURFACE_SPEED_OFF"), sOutput.format(_spindleSpeed), tool.clockwise ? getCode("START_LIVE_TOOL_CW") : getCode("START_LIVE_TOOL_CCW"));
    }
    break;
  case SPINDLE_SECONDARY: // sub spindle
    if (!gotSecondarySpindle) {
      error(localize("Secondary spindle is not available."));
      return;
    }
    if (machineState.isTurningOperation || machineState.axialCenterDrilling) {
      gSpindleModeModal.reset();
      sOutput.reset();
      if (useConstantSurfaceSpeed && !forceRPMMode) {
        writeBlock(gFormat.format(92), sOutput.format(maximumSpindleSpeed), "R2"); // spindle 1 is the default;
      }
      writeBlock(
        spindleMode,
        sOutput.format(_spindleSpeed),
        (tool.clockwise ? getCode("START_SUB_SPINDLE_CW") : getCode("START_SUB_SPINDLE_CCW")), "R2"
      ); // R1 is the default
      sOutput.reset();
    } else {
      writeBlock(spindleMode, sOutput.format(_spindleSpeed), tool.clockwise ? getCode("START_LIVE_TOOL_CW") : getCode("START_LIVE_TOOL_CCW"));
    }
    break;
  }
  lastSpindleMode = tool.getSpindleMode();
  lastSpindleSpeed = _spindleSpeed;
  lastSpindleDirection = tool.clockwise;
}

function defineMachine() {
  useTCPC = getProperty("useTCPC");
  if (modelType == "Integrex i-100") {
    gotSecondarySpindle = false;
    yAxisMinimum = toPreciseUnit(gotYAxis ? -105 : 0, MM); // specifies the minimum range for the Y-axis
    yAxisMaximum = toPreciseUnit(gotYAxis ? 105 : 0, MM); // specifies the maximum range for the Y-axis
    xAxisMinimum = toPreciseUnit(-50, MM); // specifies the maximum range for the X-axis (RADIUS MODE VALUE)
    gotMultiTurret = false; // specifies if the machine has several turrets
    maximumSpindleSpeedLive = 12000;
  } else if (modelType == "Integrex i-100S") {
    gotSecondarySpindle = true;
    yAxisMinimum = toPreciseUnit(gotYAxis ? -105 : 0, MM); // specifies the minimum range for the Y-axis
    yAxisMaximum = toPreciseUnit(gotYAxis ? 105 : 0, MM); // specifies the maximum range for the Y-axis
    xAxisMinimum = toPreciseUnit(-50, MM); // specifies the maximum range for the X-axis (RADIUS MODE VALUE)
    gotMultiTurret = false; // specifies if the machine has several turrets
    maximumSpindleSpeedLive = 12000;
  } else if (modelType == "Integrex i-200") {
    gotSecondarySpindle = false;
    yAxisMinimum = toPreciseUnit(gotYAxis ? -130 : 0, MM); // specifies the minimum range for the Y-axis
    yAxisMaximum = toPreciseUnit(gotYAxis ? 130 : 0, MM); // specifies the maximum range for the Y-axis
    xAxisMinimum = toPreciseUnit(-75, MM); // specifies the maximum range for the X-axis (RADIUS MODE VALUE)
    gotMultiTurret = false; // specifies if the machine has several turrets
    maximumSpindleSpeedLive = 12000;
  } else if (modelType == "Integrex i-200S") {
    gotSecondarySpindle = true;
    yAxisMinimum = toPreciseUnit(gotYAxis ? -130 : 0, MM); // specifies the minimum range for the Y-axis
    yAxisMaximum = toPreciseUnit(gotYAxis ? 130 : 0, MM); // specifies the maximum range for the Y-axis
    xAxisMinimum = toPreciseUnit(-75, MM); // specifies the maximum range for the X-axis (RADIUS MODE VALUE)
    gotMultiTurret = false; // specifies if the machine has several turrets
    maximumSpindleSpeedLive = 12000;
  } else if (modelType == "Integrex i-300") {
    gotSecondarySpindle = false;
    yAxisMinimum = toPreciseUnit(gotYAxis ? -130 : 0, MM); // specifies the minimum range for the Y-axis
    yAxisMaximum = toPreciseUnit(gotYAxis ? 130 : 0, MM); // specifies the maximum range for the Y-axis
    xAxisMinimum = toPreciseUnit(-75, MM); // specifies the maximum range for the X-axis (RADIUS MODE VALUE)
    gotMultiTurret = false; // specifies if the machine has several turrets
    maximumSpindleSpeedLive = 12000;
  } else if (modelType == "Integrex i-300S") {
    gotSecondarySpindle = true;
    yAxisMinimum = toPreciseUnit(gotYAxis ? -130 : 0, MM); // specifies the minimum range for the Y-axis
    yAxisMaximum = toPreciseUnit(gotYAxis ? 130 : 0, MM); // specifies the maximum range for the Y-axis
    xAxisMinimum = toPreciseUnit(-75, MM); // specifies the maximum range for the X-axis (RADIUS MODE VALUE)
    gotMultiTurret = false; // specifies if the machine has several turrets
    maximumSpindleSpeedLive = 12000;
  } else if (modelType == "Integrex i-400") {
    gotSecondarySpindle = false;
    yAxisMinimum = toPreciseUnit(gotYAxis ? -130 : 0, MM); // specifies the minimum range for the Y-axis
    yAxisMaximum = toPreciseUnit(gotYAxis ? 130 : 0, MM); // specifies the maximum range for the Y-axis
    xAxisMinimum = toPreciseUnit(-75, MM); // specifies the maximum range for the X-axis (RADIUS MODE VALUE)
    gotMultiTurret = false; // specifies if the machine has several turrets
    maximumSpindleSpeedLive = 12000;
  } else if (modelType == "Integrex i-400S") {
    gotSecondarySpindle = true;
    yAxisMinimum = toPreciseUnit(gotYAxis ? -130 : 0, MM); // specifies the minimum range for the Y-axis
    yAxisMaximum = toPreciseUnit(gotYAxis ? 130 : 0, MM); // specifies the maximum range for the Y-axis
    xAxisMinimum = toPreciseUnit(-75, MM); // specifies the maximum range for the X-axis (RADIUS MODE VALUE)
    gotMultiTurret = false; // specifies if the machine has several turrets
    maximumSpindleSpeedLive = 12000;
  }
}

/** Returns the modulus. */
function getModulus(x, y) {
  return Math.sqrt(x * x + y * y);
}

/**
  Returns the C rotation for the given X and Y coordinates.
*/
function getC(x, y) {
  var direction;
  if (Vector.dot(machineConfiguration.getAxisU().getAxis(), new Vector(0, 0, 1)) != 0) {
    direction = (machineConfiguration.getAxisU().getAxis().getCoordinate(2) >= 0) ? 1 : -1; // C-axis is the U-axis
  } else {
    direction = (machineConfiguration.getAxisV().getAxis().getCoordinate(2) >= 0) ? 1 : -1; // C-axis is the V-axis
  }

  if (g68Rotation != undefined) { // adjust X-axis for G68 rotation
    x = g68Rotation.multiply(new Vector(x, y, 0)).x;
  }
  return Math.atan2(y, x) * direction;
}

/**
  Returns the C rotation for the given X and Y coordinates in the desired rotary direction.
*/
function getCClosest(x, y, _c, clockwise) {
  if (_c == Number.POSITIVE_INFINITY) {
    _c = 0; // undefined
  }
  if (!xFormat.isSignificant(x) && !yFormat.isSignificant(y)) { // keep C if XY is on center
    return _c;
  }
  var c = getC(x, y);
  if (clockwise != undefined) {
    if (clockwise) {
      while (c < _c) {
        c += Math.PI * 2;
      }
    } else {
      while (c > _c) {
        c -= Math.PI * 2;
      }
    }
  } else {
    min = _c - Math.PI;
    max = _c + Math.PI;
    while (c < min) {
      c += Math.PI * 2;
    }
    while (c > max) {
      c -= Math.PI * 2;
    }
  }
  return c;
}

function getCWithinRange(x, y, _c, clockwise) {
  var c = getCClosest(x, y, _c, clockwise);

  var cyclicLimit;
  var cyclic;
  if (Vector.dot(machineConfiguration.getAxisU().getAxis(), new Vector(0, 0, 1)) != 0) {
    // C-axis is the U-axis
    cyclicLimit = machineConfiguration.getAxisU().getRange();
    cyclic = machineConfiguration.getAxisU().isCyclic();
  } else if (Vector.dot(machineConfiguration.getAxisV().getAxis(), new Vector(0, 0, 1)) != 0) {
    // C-axis is the V-axis
    cyclicLimit = machineConfiguration.getAxisV().getRange();
    cyclic = machineConfiguration.getAxisV().isCyclic();
  } else {
    error(localize("Unsupported rotary axis direction."));
    return 0;
  }

  // see if rewind is required
  forceRewind = false;
  if ((cFormat.getResultingValue(c) < cFormat.getResultingValue(cyclicLimit[0])) || (cFormat.getResultingValue(c) > cFormat.getResultingValue(cyclicLimit[1]))) {
    if (!cyclic) {
      forceRewind = true;
    }
    c = getCClosest(x, y, 0); // find closest C to 0
    if ((cFormat.getResultingValue(c) < cFormat.getResultingValue(cyclicLimit[0])) || (cFormat.getResultingValue(c) > cFormat.getResultingValue(cyclicLimit[1]))) {
      var midRange = cyclicLimit[0] + (cyclicLimit[1] - cyclicLimit[0]) / 2;
      c = getCClosest(x, y, midRange); // find closest C to midRange
    }
    if ((cFormat.getResultingValue(c) < cFormat.getResultingValue(cyclicLimit[0])) || (cFormat.getResultingValue(c) > cFormat.getResultingValue(cyclicLimit[1]))) {
      error(localize("Unable to find C-axis position within the defined range."));
      return 0;
    }
  }
  return c;
}

/**
  Returns the desired tolerance for the given section.
*/
function getTolerance() {
  var t = tolerance;
  if (hasParameter("operation:tolerance")) {
    if (t > 0) {
      t = Math.min(t, getParameter("operation:tolerance"));
    } else {
      t = getParameter("operation:tolerance");
    }
  }
  return t;
}

function formatSequenceNumber() {
  if (sequenceNumber > 99999) {
    sequenceNumber = getProperty("sequenceNumberStart");
  }
  var seqno = "N" + sequenceNumber;
  sequenceNumber += getProperty("sequenceNumberIncrement");
  return seqno;
}

/**
  Writes the specified block.
*/
function writeBlock() {
  var seqno = "";
  var opskip = "";
  if (showSequenceNumbers == "true") {
    seqno = formatSequenceNumber();
  }
  if (optionalSection) {
    opskip = "/";
  }
  var text = formatWords(arguments);
  if (text) {
    writeWords(opskip, seqno, text);
    if (getProperty("showSequenceNumbers") == "toolChange") {
      showSequenceNumbers = "false";
    }
  }
}

/**
  Writes the specified optional block.
*/
function writeOptionalBlock() {
  if (showSequenceNumbers == "true") {
    var words = formatWords(arguments);
    if (words) {
      writeWords("/", "N" + sequenceNumber, words);
      sequenceNumber += getProperty("sequenceNumberIncrement");
    }
  } else {
    writeWords2("/", arguments);
  }
}

function formatComment(text) {
  return "(" + filterText(String(text).toUpperCase(), permittedCommentChars) + ")";
}

/**
  Output a comment.
*/
function writeComment(text) {
  writeln(formatComment(text));
}

var machineConfigurationMainSpindle;
var machineConfigurationSubSpindle;

function onOpen() {
  defineMachine();

  if (getProperty("useRadius")) {
    maximumCircularSweep = toRad(90); // avoid potential center calculation errors for CNC
  }
  // Copy certain properties into global variables
  transferUseTorque = getProperty("transferUseTorque");
  if (true) {
    // make sure parameter F85 Bit 2 is set for 5 axis simultaneous
    var bAxisMain = createAxis({coordinate:1, table:false, axis:[0, -1, 0], range:[-30, 210], preference:0});
    var cAxisMain = createAxis({coordinate:2, table:true, axis:[0, 0, 1], range:[-360, 360], cyclic:true, preference:0});

    var bAxisSub = createAxis({coordinate:1, table:false, axis:[0, 1, 0], range:[-30, 210], preference:0});
    var cAxisSub = createAxis({coordinate:2, table:true, axis:[0, 0, -1], range:[-360, 360], cyclic:true, preference:0});

    machineConfigurationMainSpindle = gotBAxis ? new MachineConfiguration(bAxisMain, cAxisMain) : new MachineConfiguration(cAxisMain);
    machineConfigurationSubSpindle =  gotBAxis ? new MachineConfiguration(bAxisSub, cAxisSub) : new MachineConfiguration(cAxisSub);
  }

  machineConfiguration = new MachineConfiguration(); // creates an empty configuration to be able to set eg vendor information

  machineConfiguration.setModel(modelType);

  if (!gotYAxis) {
    yOutput.disable();
  }
  aOutput.disable();
  if (!gotBAxis) {
    bOutput.disable();
  }
  reverseAxes = getProperty("reverseAxes", true);

  if (!getProperty("separateWordsWithSpace")) {
    setWordSeparator("");
  }
  showSequenceNumbers = getProperty("showSequenceNumbers");
  sequenceNumber = getProperty("sequenceNumberStart");

  if (programName) {
    if (programComment) {
      writeln(formatComment(programComment));
    } else {
      //writeln("O" + programName);
    }
  } else {
    error(localize("Program name has not been specified."));
    return;
  }

  if (getProperty("writeVersion")) {
    if ((typeof getHeaderVersion == "function") && getHeaderVersion()) {
      writeComment(localize("post version") + ": " + getHeaderVersion());
    }
    if ((typeof getHeaderDate == "function") && getHeaderDate()) {
      writeComment(localize("post modified") + ": " + getHeaderDate());
    }
  }

  // dump machine configuration
  var vendor = machineConfiguration.getVendor();
  var model = machineConfiguration.getModel();
  var description = machineConfiguration.getDescription();

  if (getProperty("writeMachine") && (vendor || model || description)) {
    writeComment(localize("Machine"));
    if (vendor) {
      writeComment("  " + localize("vendor") + " - " + vendor);
    }
    if (model) {
      writeComment(" " + localize("model") + " - " + model);
    }
    if (description) {
      writeComment("  " + localize("description") + " - "  + description);
    }
    writeComment(" " + localize("Controller Type - " + getProperty("controllerType")));
  }

  // dump tool information
  var toolData = new Array();
  var toolFormat = createFormat({zeropad:false});
  if (getProperty("writeTools")) {
    var zRanges = {};
    var numberOfSections = getNumberOfSections();
    for (var i = 0; i < numberOfSections; ++i) {
      var section = getSection(i);
      var tool = section.getTool();
      if (is3D()) {
        var zRange = section.getGlobalZRange();
        if (zRanges[tool.number]) {
          zRanges[tool.number].expandToRange(zRange);
        } else {
          zRanges[tool.number] = zRange;
        }
      }
      if (tool.isTurningTool()) {
        toolData[tool.number] = {dia:0, rad:0, hgt:0};
        toolData[tool.number].dia = section.hasParameter("operation:tool_diameter") ?
          section.getParameter("operation:tool_diameter") : 0;
        toolData[tool.number].rad = section.hasParameter("operation:tool_cornerRadius") ?
          section.getParameter("operation:tool_cornerRadius") : 0;
        toolData[tool.number].hgt = section.hasParameter("operation:tool_thickness") ?
          section.getParameter("operation:tool_thickness") : 0;
        if (unit == IN) {   // TAG: Tool parameters are always in MM?
          toolData[tool.number].dia /= 25.4;
          toolData[tool.number].rad /= 25.4;
          toolData[tool.number].hgt /= 25.4;
        }
      }
    }

    var tools = getToolTable();
    if (tools.getNumberOfTools() > 0) {
      for (var i = 0; i < tools.getNumberOfTools(); ++i) {
        var tool = tools.getTool(i);
        if (tool.isTurningTool()) {
          var compensationOffset = tool.compensationOffset;
          var comment = "T" + toolFormat.format(tool.number) + conditional(tool.productId, ".") + tool.productId + " " +
            "DIA=" + spatialFormat.format(toolData[tool.number].dia) + " " +
            localize("RAD=") + spatialFormat.format(toolData[tool.number].rad) + " " +
            localize("HGT=") + spatialFormat.format(toolData[tool.number].hgt);
        } else {
          var compensationOffset = tool.lengthOffset;
          var comment = "T" + toolFormat.format(tool.number) + conditional(tool.productId, ".") + tool.productId + " " +
            "D=" + spatialFormat.format(tool.diameter) + " " +
            localize("CR") + "=" + spatialFormat.format(tool.cornerRadius);
          if ((tool.taperAngle > 0) && (tool.taperAngle < Math.PI)) {
            comment += " " + localize("TAPER") + "=" + taperFormat.format(tool.taperAngle) + localize("deg");
          }
          if (zRanges[tool.number]) {
            comment += " - " + localize("ZMIN") + "=" + spatialFormat.format(zRanges[tool.number].getMinimum());
          }
        }
        comment += " - " + getToolTypeName(tool.type);
        writeComment(comment);
      }
    }
  }

  if (false) {
    // check for duplicate tool number
    for (var i = 0; i < getNumberOfSections(); ++i) {
      var sectioni = getSection(i);
      var tooli = sectioni.getTool();
      for (var j = i + 1; j < getNumberOfSections(); ++j) {
        var sectionj = getSection(j);
        var toolj = sectionj.getTool();
        if (tooli.number == toolj.number) {
          if (spatialFormat.areDifferent(tooli.diameter, toolj.diameter) ||
              spatialFormat.areDifferent(tooli.cornerRadius, toolj.cornerRadius) ||
              abcFormat.areDifferent(tooli.taperAngle, toolj.taperAngle) ||
              (tooli.numberOfFlutes != toolj.numberOfFlutes)) {
            error(
              subst(
                localize("Using the same tool number for different cutter geometry for operation '%1' and '%2'."),
                sectioni.hasParameter("operation-comment") ? sectioni.getParameter("operation-comment") : ("#" + (i + 1)),
                sectionj.hasParameter("operation-comment") ? sectionj.getParameter("operation-comment") : ("#" + (j + 1))
              )
            );
            return;
          }
        }
      }
    }
  }
  var usesPrimarySpindle = false;
  var usesSecondarySpindle = false;
  for (var i = 0; i < getNumberOfSections(); ++i) {
    var section = getSection(i);
    if (section.getType() != TYPE_TURNING) {
      continue;
    }
    switch (section.spindle) {
    case SPINDLE_PRIMARY:
      usesPrimarySpindle = true;
      break;
    case SPINDLE_SECONDARY:
      usesSecondarySpindle = true;
      break;
    }
  }

  if ((getNumberOfSections() > 0) && (getSection(0).workOffset == 0)) {
    for (var i = 0; i < getNumberOfSections(); ++i) {
      if (getSection(i).workOffset > 0) {
        error(localize("Using multiple work offsets is not possible if the initial work offset is 0."));
        return;
      }
    }
  }

  if (getProperty("writeDateAndTime")) {
    var date = new Date(Date.now());
    writeComment(date.toDateString() + " - " + date.getHours().toString() + ":" + date.getMinutes().toString());
  }
  //writeBlock("#" + xHomeParameter + "=" + spatialFormat.format(getProperty("homePositionX")) + "(PARAMETER FOR X HOME POSITION)"); // retract
  writeBlock("#" + zHomeParameter + "=" + spatialFormat.format(getProperty("homePositionZ")) + "(PARAMETER FOR Z HOME POSITION)"); // retract
  if (gotYAxis) {
    //writeBlock("#" + yHomeParameter + "=" + spatialFormat.format(getProperty("homePositionY")) + "(PARAMETER FOR Y HOME POSITION)"); // retract
  }
  if (gotSecondarySpindle) {
    writeBlock("#" + zSubHomeParameter + "=" + spatialFormat.format(getProperty("homePositionSubZ")) + "(PARAMETER FOR SUB Z HOME POSITION)"); // retract
    writeBlock("#501=0.", "(DISTANCE SUB FACE TO Z0 ON MAIN)");
  }
  writeln("");
  switch (unit) {
  case IN:
    writeBlock(gUnitModal.format(20));
    break;
  case MM:
    writeBlock(gUnitModal.format(21));
    break;
  }
  writeBlock(gMotionModal.format(0), gAbsIncModal.format(90), getCode("FEED_MODE_UNIT_MIN"), gFormat.format(getSection(0).spindle == SPINDLE_PRIMARY ? 54 : 55), getCode("CONSTANT_SURFACE_SPEED_OFF"));
  writeBlock(gFormat.format(40), gFormat.format(49), gFormat.format(80), gFormat.format(67), gRotationModal.format(69), gPlaneModal.format(18));
  writeln("");

  if (usesPrimarySpindle) {
    writeBlock(gFormat.format(92), sOutput.format(getProperty("maximumSpindleSpeed")), "R1"); // spindle 1 is the default
    sOutput.reset();
  }

  if (gotSecondarySpindle) {
    if (usesSecondarySpindle) {
      writeBlock(gFormat.format(92), sOutput.format(getProperty("maximumSpindleSpeed")), "R2");
      sOutput.reset();
    }
  }

  onCommand(COMMAND_START_CHIP_TRANSPORT);
}

function onComment(message) {
  writeComment(message);
}

/** Force output of X, Y, and Z. */
function forceXYZ() {
  xOutput.reset();
  yOutput.reset();
  zOutput.reset();
}

/** Force output of A, B, and C. */
function forceABC() {
  aOutput.reset();
  bOutput.reset();
  cOutput.reset();
}

function forceFeed() {
  currentFeedId = undefined;
  feedOutput.reset();
}

/** Force output of X, Y, Z, A, B, C, and F on next output. */
function forceAny() {
  forceXYZ();
  forceABC();
  forceFeed();
}

function FeedContext(id, description, feed) {
  this.id = id;
  this.description = description;
  this.feed = feed;
}

function getFeed(f) {
  if (activeMovements) {
    var feedContext = activeMovements[movement];
    if (feedContext != undefined) {
      if (!feedFormat.areDifferent(feedContext.feed, f)) {
        if (feedContext.id == currentFeedId) {
          return ""; // nothing has changed
        }
        forceFeed();
        currentFeedId = feedContext.id;
        return "F#" + (firstFeedParameter + feedContext.id);
      }
    }
    currentFeedId = undefined; // force Q feed next time
  }
  if (machineState.feedPerRevolution) {
    f = (feedFormat.format(f) <= 0) ? (Math.pow(10, feedFormat.getNumberOfDecimals() * -1)) : f;
  }
  return feedOutput.format(f); // use feed value
}

function initializeActiveFeeds() {
  activeMovements = new Array();
  var movements = currentSection.getMovements();
  var feedPerRev = currentSection.feedMode == FEED_PER_REVOLUTION;

  var id = 0;
  var activeFeeds = new Array();
  if (hasParameter("operation:tool_feedCutting")) {
    if (movements & ((1 << MOVEMENT_CUTTING) | (1 << MOVEMENT_LINK_TRANSITION) | (1 << MOVEMENT_EXTENDED))) {
      var feedContext = new FeedContext(id, localize("Cutting"), feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_CUTTING] = feedContext;
      if (!hasParameter("operation:tool_feedTransition")) {
        activeMovements[MOVEMENT_LINK_TRANSITION] = feedContext;
      }
      activeMovements[MOVEMENT_EXTENDED] = feedContext;
    }
    ++id;
    if (movements & (1 << MOVEMENT_PREDRILL)) {
      feedContext = new FeedContext(id, localize("Predrilling"), feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"));
      activeMovements[MOVEMENT_PREDRILL] = feedContext;
      activeFeeds.push(feedContext);
    }
    ++id;
  }

  if (hasParameter("operation:finishFeedrate")) {
    if (movements & (1 << MOVEMENT_FINISH_CUTTING)) {
      var finishFeedrateRel;
      if (hasParameter("operation:finishFeedrateRel")) {
        finishFeedrateRel = getParameter("operation:finishFeedrateRel");
      } else if (hasParameter("operation:finishFeedratePerRevolution")) {
        finishFeedrateRel = getParameter("operation:finishFeedratePerRevolution");
      }
      var feedContext = new FeedContext(id, localize("Finish"), feedPerRev ? finishFeedrateRel : getParameter("operation:finishFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_FINISH_CUTTING] = feedContext;
    }
    ++id;
  } else if (hasParameter("operation:tool_feedCutting")) {
    if (movements & (1 << MOVEMENT_FINISH_CUTTING)) {
      var feedContext = new FeedContext(id, localize("Finish"), feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_FINISH_CUTTING] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:tool_feedEntry")) {
    if (movements & (1 << MOVEMENT_LEAD_IN)) {
      var feedContext = new FeedContext(id, localize("Entry"), feedPerRev ? getParameter("operation:tool_feedEntryRel") : getParameter("operation:tool_feedEntry"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LEAD_IN] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:tool_feedExit")) {
    if (movements & (1 << MOVEMENT_LEAD_OUT)) {
      var feedContext = new FeedContext(id, localize("Exit"), feedPerRev ? getParameter("operation:tool_feedExitRel") : getParameter("operation:tool_feedExit"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LEAD_OUT] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:noEngagementFeedrate")) {
    if (movements & (1 << MOVEMENT_LINK_DIRECT)) {
      var feedContext = new FeedContext(id, localize("Direct"), feedPerRev ? getParameter("operation:noEngagementFeedrateRel") : getParameter("operation:noEngagementFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LINK_DIRECT] = feedContext;
    }
    ++id;
  } else if (hasParameter("operation:tool_feedCutting") &&
             hasParameter("operation:tool_feedEntry") &&
             hasParameter("operation:tool_feedExit")) {
    if (movements & (1 << MOVEMENT_LINK_DIRECT)) {
      var feedContext = new FeedContext(
        id,
        localize("Direct"),
        Math.max(
          feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"),
          feedPerRev ? getParameter("operation:tool_feedEntryRel") : getParameter("operation:tool_feedEntry"),
          feedPerRev ? getParameter("operation:tool_feedExitRel") : getParameter("operation:tool_feedExit")
        )
      );
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LINK_DIRECT] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:reducedFeedrate")) {
    if (movements & (1 << MOVEMENT_REDUCED)) {
      var feedContext = new FeedContext(id, localize("Reduced"), feedPerRev ? getParameter("operation:reducedFeedrateRel") : getParameter("operation:reducedFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_REDUCED] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:tool_feedRamp")) {
    if (movements & ((1 << MOVEMENT_RAMP) | (1 << MOVEMENT_RAMP_HELIX) | (1 << MOVEMENT_RAMP_PROFILE) | (1 << MOVEMENT_RAMP_ZIG_ZAG))) {
      var feedContext = new FeedContext(id, localize("Ramping"), feedPerRev ? getParameter("operation:tool_feedRampRel") : getParameter("operation:tool_feedRamp"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_RAMP] = feedContext;
      activeMovements[MOVEMENT_RAMP_HELIX] = feedContext;
      activeMovements[MOVEMENT_RAMP_PROFILE] = feedContext;
      activeMovements[MOVEMENT_RAMP_ZIG_ZAG] = feedContext;
    }
    ++id;
  }
  if (hasParameter("operation:tool_feedPlunge")) {
    if (movements & (1 << MOVEMENT_PLUNGE)) {
      var feedContext = new FeedContext(id, localize("Plunge"), feedPerRev ? getParameter("operation:tool_feedPlungeRel") : getParameter("operation:tool_feedPlunge"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_PLUNGE] = feedContext;
    }
    ++id;
  }
  if (true) { // high feed
    if ((movements & (1 << MOVEMENT_HIGH_FEED)) || (highFeedMapping != HIGH_FEED_NO_MAPPING)) {
      var feed;
      if (hasParameter("operation:highFeedrateMode") && getParameter("operation:highFeedrateMode") != "disabled") {
        feed = getParameter("operation:highFeedrate");
      } else {
        feed = this.highFeedrate;
      }
      var feedContext = new FeedContext(id, localize("High Feed"), feed);
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_HIGH_FEED] = feedContext;
      activeMovements[MOVEMENT_RAPID] = feedContext;
    }
    ++id;
  }
  if (hasParameter("operation:tool_feedTransition")) {
    if (movements & (1 << MOVEMENT_LINK_TRANSITION)) {
      var feedContext = new FeedContext(id, localize("Transition"), getParameter("operation:tool_feedTransition"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LINK_TRANSITION] = feedContext;
    }
    ++id;
  }

  for (var i = 0; i < activeFeeds.length; ++i) {
    var feedContext = activeFeeds[i];
    writeBlock("#" + (firstFeedParameter + feedContext.id) + "=" + feedFormat.format(feedContext.feed), formatComment(feedContext.description));
  }
}

var currentSmoothing = false;

function setSmoothing(mode) {
  if (mode == currentSmoothing) {
    return;
  }
  currentSmoothing = mode;
  writeBlock(gFormat.format(5), mode ? "P2" : "P0");
}

var currentGeoComp = false;

function setGeometryComp(mode) {
  if (mode == currentGeoComp) {
    return;
  }
  currentGeoComp = mode;
  if (mode) {
    writeBlock(gFormat.format(61.1), (conditional(getProperty("controllerType") == "Smooth", "P0")));
  } else {
    writeBlock(gFormat.format(64));
  }
}

var currentWorkPlaneABC = undefined;

function forceWorkPlane() {
  currentWorkPlaneABC = undefined;
}

function setWorkPlane(abc) {
  // milling only

  if (!machineConfiguration.isMultiAxisConfiguration()) {
    return; // ignore
  }

  if (!((currentWorkPlaneABC == undefined) ||
        abcFormat.areDifferent(abc.x, currentWorkPlaneABC.x) ||
        abcFormat.areDifferent(abc.y, currentWorkPlaneABC.y) ||
        abcFormat.areDifferent(abc.z, currentWorkPlaneABC.z))) {
    return; // no change
  }

  if (useMultiAxisFeatures && useTCPC) {
    if (abc.isNonZero()) {
      onCommand(COMMAND_UNLOCK_MULTI_AXIS);
      writeBlock(gRotationModal.format(69));
      var initialToolAxisBC = machineConfiguration.getABC(currentSection.workPlane);
      writeBlock(gRotationModal.format(68.2), "X" + spatialFormat.format(0), "Y" + spatialFormat.format(0), "Z" + spatialFormat.format(0), "I" + abcFormat.format(abc.x), "J" + abcFormat.format(abc.y), "K" + abcFormat.format(abc.z)); // set frame
      writeBlock(gFormat.format(53.1), formatComment("B" + abcFormat.format(initialToolAxisBC.y)), formatComment("C" + abcFormat.format(initialToolAxisBC.z))); // turn machine
    }
  } else {
    onCommand(COMMAND_UNLOCK_MULTI_AXIS);
    if (abc.y != 0) {
      writeBlock(gRotationModal.format(69));
      if (!machineState.spindlesAreAttached) {
        forceABC();
        writeBlock(
          gMotionModal.format(0),
          conditional(machineConfiguration.isMachineCoordinate(0), aOutput.format(abc.x)),
          conditional(machineConfiguration.isMachineCoordinate(1), bOutput.format(abc.y)),
          conditional(machineConfiguration.isMachineCoordinate(2), cOutput.format(abc.z))
        );
      }
      writeBlock(gRotationModal.format(68), "X" + spatialFormat.format(0), "Y" + spatialFormat.format(0), "Z" + spatialFormat.format(0), "I" + spatialFormat.format(0), "J" + spatialFormat.format(1), "K" + spatialFormat.format(0), "R" + abcFormat.format(abc.y)); // set frame
    } else {
      cOutput.reset();
      writeBlock(
        gMotionModal.format(0),
        conditional(machineConfiguration.isMachineCoordinate(0), aOutput.format(abc.x)),
        conditional(machineConfiguration.isMachineCoordinate(1), bOutput.format(abc.y)),
        conditional(machineConfiguration.isMachineCoordinate(2), cOutput.format(abc.z))
      );
    }
    g68Rotation = Matrix.getYRotation(abc.y);
  }

  // Don't clamp the C axis if the machine is using polar, only clamp the B (if it exists)
  if (!machineState.usePolarMode && !machineState.useXZCMode) {
    if (!machineState.spindlesAreAttached) {
      onCommand(COMMAND_LOCK_MULTI_AXIS);
    }
  } else if (gotBAxis) {
    writeBlock(getCode("CLAMP_B_AXIS")); // B-axis
  }

  currentWorkPlaneABC = new Vector(abc.x, abc.y, abc.z);
  previousABC = abc;
}

function getBestABCIndex(section) {
  var fitFlag = false;
  var index = undefined;
  for (var i = 0; i < 6; ++i) {
    fitFlag = doesToolpathFitInXYRange(getBestABC(section, section.workPlane, i));
    if (fitFlag) {
      index = i;
      break;
    }
  }
  return index;
}

function getBestABC(section, workPlane, which) {
  var W = workPlane;
  var abc = machineConfiguration.getABC(W);
  if ((which == undefined) || useMultiAxisFeatures) { // turning, XZC, Polar modes
    // we cannot search for bestABC if useMultiAxisFeatures is enabled since it requires Euler angles in setWorkPlane
    return abc;
  }
  if (Vector.dot(machineConfiguration.getAxisU().getAxis(), new Vector(0, 0, 1)) != 0) {
    var axis = machineConfiguration.getAxisU(); // C-axis is the U-axis
  } else {
    var axis = machineConfiguration.getAxisV(); // C-axis is the V-axis
  }
  if (axis.isEnabled() && axis.isTable()) {
    var ix = axis.getCoordinate();
    var rotAxis = axis.getAxis();
    if (isSameDirection(machineConfiguration.getDirection(abc), rotAxis) ||
        isSameDirection(machineConfiguration.getDirection(abc), Vector.product(rotAxis, -1))) {
      var direction = isSameDirection(machineConfiguration.getDirection(abc), rotAxis) ? 1 : -1;
      var box = section.getGlobalBoundingBox();
      switch (which) {
      case 1:
        x = 1;
        y = 0;
        break;
      case 2:
        x = 0;
        y = 1;
        break;
      case 3:
        x = -1;
        y = 0;
        break;
      case 4:
        x = 0;
        y = -1;
        break;
      case 5:
        x = box.upper.x - box.lower.x;
        y = box.upper.y - box.lower.y;
        break;
      case 6:
        x = box.lower.x;
        y = box.lower.y;
        break;
      case 7:
        x = box.upper.x;
        y = box.lower.y;
        break;
      case 8:
        x = box.upper.x;
        y = box.upper.y;
        break;
      case 9:
        x = box.lower.x;
        y = box.upper.y;
        break;
      default:
        var R = machineConfiguration.getRemainingOrientation(abc, W);
        x = R.right.x;
        y = R.right.y;
        break;
      }
      abc.setCoordinate(ix, getCClosest(x, y, cOutput.getCurrent()));
    }
  }
  // writeComment("Which = " + which + "  Angle = " + abc.z)
  return abc;
}

var closestABC = false; // choose closest machine angles
var currentMachineABC = new Vector(0, 0, 0);

function getWorkPlaneMachineABC(section, workPlane) {
  var W = workPlane; // map to global frame

  var abc;
  if ((machineState.isTurningOperation || machineState.axialCenterDrilling) && gotBAxis) {
    var both = machineConfiguration.getABCByDirectionBoth(workPlane.forward);
    abc = both[0];
    if (both[0].z != 0) {
      abc = both[1];
    }
  } else {
    abc = getBestABC(section, workPlane, bestABCIndex);
    if (closestABC) {
      if (currentMachineABC) {
        abc = machineConfiguration.remapToABC(abc, currentMachineABC);
      } else {
        abc = machineConfiguration.getPreferredABC(abc);
      }
    } else {
      abc = machineConfiguration.getPreferredABC(abc);
    }
  }

  try {
    abc = machineConfiguration.remapABC(abc);
    currentMachineABC = abc;
  } catch (e) {
    error(
      localize("Machine angles not supported") + ":"
      + conditional(machineConfiguration.isMachineCoordinate(0), " A" + abcFormat.format(abc.x))
      + conditional(machineConfiguration.isMachineCoordinate(1), " B" + abcFormat.format(abc.y))
      + conditional(machineConfiguration.isMachineCoordinate(2), " C" + abcFormat.format(abc.z))
    );
  }

  var direction = machineConfiguration.getDirection(abc);
  if (!isSameDirection(direction, W.forward)) {
    error(localize("Orientation not supported."));
  }

  if ((machineState.isTurningOperation || machineState.axialCenterDrilling) && gotBAxis) { // remapABC can change the B-axis orientation
    if (abc.z != 0) {
      error(localize("Could not calculate a B-axis turning angle within the range of the machine."));
      return abc;
    }
  }

  if (!machineConfiguration.isABCSupported(abc)) {
    error(
      localize("Work plane is not supported") + ":"
      + conditional(machineConfiguration.isMachineCoordinate(0), " A" + abcFormat.format(abc.x))
      + conditional(machineConfiguration.isMachineCoordinate(1), " B" + abcFormat.format(abc.y))
      + conditional(machineConfiguration.isMachineCoordinate(2), " C" + abcFormat.format(abc.z))
    );
  }

  if (!machineState.isTurningOperation) {
    var tcp = false;
    if (tcp) {
      setRotation(W); // TCP mode
    } else {
      var O = machineConfiguration.getOrientation(abc);
      var R = machineConfiguration.getRemainingOrientation(abc, W);
      setRotation(R);
    }
  }
  return abc;
}

function getBAxisOrientationTurning(section) {
  var abc = new Vector(0, 0, 0);
  var toolAngle = hasParameter("operation:tool_angle") ? getParameter("operation:tool_angle") : 0;
  var toolOrientation = section.toolOrientation;
  if (toolAngle && (toolOrientation != 0)) {
    error(localize("You cannot use tool angle and tool orientation together in operation " + "\"" + (getParameter("operation-comment")) + "\""));
    return abc;
  }
  if (!machineState.axialCenterDrilling) {
    var angle = toRad(toolAngle) + toolOrientation;

    var axis = new Vector(0, 1, 0);
    var mappedAngle = (section.spindle == SPINDLE_PRIMARY ? (Math.PI / 2 - angle) : (Math.PI / 2 - angle));
    var mappedWorkplane = new Matrix(axis, mappedAngle);
    abc = getWorkPlaneMachineABC(section, mappedWorkplane);
  } else {
    abc = getWorkPlaneMachineABC(section, section.workPlane);
  }
  return abc;
}

function getSpindle(partSpindle) {
  // safety conditions
  if (getNumberOfSections() == 0) {
    return SPINDLE_MAIN;
  }
  if (getCurrentSectionId() < 0) {
    if (machineState.liveToolIsActive && !partSpindle) {
      return SPINDLE_LIVE;
    } else {
      return getSection(getNumberOfSections() - 1).spindle;
    }
  }

  // Turning is active or calling routine requested which spindle part is loaded into
  if (machineState.isTurningOperation || machineState.axialCenterDrilling || partSpindle) {
    return currentSection.spindle;
  //Milling is active
  } else {
    return SPINDLE_LIVE;
  }
}

function getSecondarySpindle() {
  var spindle = getSpindle(PART);
  return (spindle == SPINDLE_MAIN) ? SPINDLE_SUB : SPINDLE_MAIN;
}

function invertAxes(activate, polarMode) {
  var scaleValue = reverseAxes ? -1 : 1;
  var yAxisPrefix = polarMode ? (activate ? "U" : "C") : "Y";
  var yIsEnabled = yOutput.isEnabled();
  yFormat.setScale(activate ? scaleValue : 1);
  zFormat.setScale(activate ? -1 : 1);

  yOutput = createVariable({onchange:function() {yAxisIsRetracted = false;}, prefix:yAxisPrefix}, yFormat);
  zOutput = createVariable({prefix:"Z"}, zFormat);
  if (polarMode) {
    cOutput.disable();
  } else {
    cOutput = createVariable({prefix:(activate ? "U" : "C")}, cFormat);
    if (!yIsEnabled) {
      yOutput.disable();
    }
  }
  jOutput = createReferenceVariable({prefix:"J", force:true}, yFormat);
  kOutput = createReferenceVariable({prefix:"K", force:true}, zFormat);
}

/** determines if the axes in the given plane are mirrored */
function isMirrored(plane) {
  plane = plane == -1 ? getCompensationPlane(previousABC, false, false) : plane;
  switch (plane) {
  case PLANE_XY:
    if ((xFormat.getScale() * yFormat.getScale()) < 0) {
      return true;
    }
    break;
  case PLANE_YZ:
    if ((yFormat.getScale() * zFormat.getScale()) < 0) {
      return true;
    }
    break;
  case PLANE_ZX:
    if ((zFormat.getScale() * xFormat.getScale()) < 0) {
      return true;
    }
    break;
  }
  return false;
}

function onSection() {
  /** detect machine configuration */
  machineConfiguration = (currentSection.spindle == SPINDLE_PRIMARY) ? machineConfigurationMainSpindle : machineConfigurationSubSpindle;
  if (!gotBAxis) {
    if (getMachiningDirection(currentSection) == MACHINING_DIRECTION_AXIAL && !currentSection.isMultiAxis()) {
      machineConfiguration.setSpindleAxis(new Vector(0, 0, 1));
    } else {
      machineConfiguration.setSpindleAxis(new Vector(1, 0, 0));
    }
  } else {
    if (currentSection.spindle == SPINDLE_PRIMARY) {
      machineConfiguration.setSpindleAxis(new Vector(0, 0, 1));
    } else {
      machineConfiguration.setSpindleAxis(new Vector(0, 0, -1));
    }
  }

  setMachineConfiguration(machineConfiguration);
  currentSection.optimizeMachineAnglesByMachine(machineConfiguration, getProperty("tableAdjust") ? 2 : 0); // map tip mode

  var forceToolAndRetract = optionalSection && !currentSection.isOptional();
  optionalSection = currentSection.isOptional();
  bestABCIndex = undefined;

  var yAxisWasEnabled = !machineState.useXZCMode && !machineState.usePolarMode && machineState.liveToolIsActive;

  updateMachiningMode(currentSection); // sets the needed machining mode to machineState (usePolarMode, useXZCMode, axialCenterDrilling)

  if (isFirstSection()) {
    previousBAxisOrientationTurning = new Vector(machineState.bAxisOrientationTurning);
  }

  var insertToolCall = forceToolAndRetract || isFirstSection() ||
    currentSection.getForceToolChange && currentSection.getForceToolChange() ||
    (tool.number != getPreviousSection().getTool().number) ||
    (tool.compensationOffset != getPreviousSection().getTool().compensationOffset) ||
    (tool.diameterOffset != getPreviousSection().getTool().diameterOffset) ||
    (tool.lengthOffset != getPreviousSection().getTool().lengthOffset);

  retracted = false; // specifies that the tool has been retracted to the safe plane
  var newSpindle = isFirstSection() ||
    (getPreviousSection().spindle != currentSection.spindle);

  // Get the active spindle
  var newSpindle = true;
  var tempSpindle = getSpindle(TOOL);
  var tempPartSpindle = getSpindle(PART);
  if (isFirstSection()) {
    previousSpindle = tempSpindle;
    previousPartSpindle = currentSection.spindle;
  }
  newSpindle = tempSpindle != previousSpindle || tempPartSpindle != previousPartSpindle;

  var newWorkOffset = isFirstSection() ||
    (getPreviousSection().workOffset != currentSection.workOffset); // work offset changes
  var newWorkPlane = isFirstSection() ||
    !isSameDirection(getPreviousSection().getGlobalFinalToolAxis(), currentSection.getGlobalInitialToolAxis()) ||
    (machineState.isTurningOperation &&
      abcFormat.areDifferent(machineState.bAxisOrientationTurning.x, previousBAxisOrientationTurning.x) ||
      abcFormat.areDifferent(machineState.bAxisOrientationTurning.y, previousBAxisOrientationTurning.y) ||
      abcFormat.areDifferent(machineState.bAxisOrientationTurning.z, previousBAxisOrientationTurning.z)) ||
      (!getPreviousSection().isMultiAxis() && currentSection.isMultiAxis() ||
      getPreviousSection().isMultiAxis() && !currentSection.isMultiAxis()); // force newWorkPlane between indexing and simultaneous

  partCutoff = hasParameter("operation-strategy") &&
      (getParameter("operation-strategy") == "turningPart");

  if (newWorkPlane || insertToolCall || newSpindle) {
    writeBlock(gRotationModal.format(69));
    forceWorkPlane();
  }

  if (insertToolCall || newSpindle || newWorkOffset || newWorkPlane) {
    if (machineState.liveToolIsActive) {
      writeBlock(getCode("STOP_LIVE_TOOL"));
    }
    if (machineState.mainSpindleIsActive) {
      writeBlock(getCode("STOP_MAIN_SPINDLE"));
    }
    if (machineState.subSpindleIsActive) {
      writeBlock(getCode("STOP_SUB_SPINDLE"));
    }
    lastSpindleSpeed = 0;
    lastSpindleDirection = undefined;
    sOutput.reset();

    // retract to safe plane
    setCoolant(COOLANT_OFF, machineState.currentTurret);
    if (!machineState.spindlesAreAttached) {
      writeRetract(X, Y);
      // writeRetract(Z);
      if (isFirstSection()) {
        onCommand(COMMAND_UNLOCK_MULTI_AXIS);
        gMotionModal.reset();
        writeBlock(gMotionModal.format(0), gAbsIncModal.format(90), gFormat.format(53), bOutput.format(toRad(0)));
      }
    } else {
      onCommand(COMMAND_UNLOCK_MULTI_AXIS);
      writeRetract(X, Y);
      writeBlock(gFormat.format(0), gFormat.format(53), bOutput.format(0), ("Z#" + ((currentSection.spindle == SPINDLE_SECONDARY) ? zSubHomeParameter : zHomeParameter)));
    }
    forceAny();
  }

  if (getProperty("tiltedPlaneMethod") == "G68" || machineState.usePolarMode || (currentSection.spindle == SPINDLE_SECONDARY)) {
    useMultiAxisFeatures = false;
  } else {
    useMultiAxisFeatures = true;
  }

  if (getProperty("optionalStop")) {
    onCommand(COMMAND_OPTIONAL_STOP);
    gMotionModal.reset();
  }
  writeln("");

  // Consider part cutoff as stockTransfer operation
  if (!(machineState.stockTransferIsActive && partCutoff)) {
    machineState.stockTransferIsActive = false;
  }

  if (hasParameter("operation-comment")) {
    var comment = getParameter("operation-comment");
    if (comment) {
      writeComment(comment);
    }
  }

  if (getProperty("showNotes") && hasParameter("notes")) {
    var notes = getParameter("notes");
    if (notes) {
      var lines = String(notes).split("\n");
      var r1 = new RegExp("^[\\s]+", "g");
      var r2 = new RegExp("[\\s]+$", "g");
      for (line in lines) {
        var comment = lines[line].replace(r1, "").replace(r2, "");
        if (comment) {
          writeComment(comment);
        }
      }
    }
  }

  if (insertToolCall) {
    forceWorkPlane();
    gPlaneModal.reset();
    gFeedModeModal.reset();

    setCoolant(COOLANT_OFF, machineState.currentTurret);
    var toolFormat = createFormat({width:2, zeropad:true});
    if (getProperty("showSequenceNumbers") == "toolChange") {
      showSequenceNumbers = "true";
    }
    if (getProperty("preloadTool")) {
      var nextTool = getNextTool(tool.number);
      if (nextTool) {
        nextool = "T" + toolFormat.format(nextTool.number);
      } else {
        // preload first tool
        var section = getSection(0);
        var firstToolNumber = section.getTool().number;
        if (tool.number != firstToolNumber) {
          nextool = "T" + toolFormat.format(firstToolNumber);
        } else {
          nextool = "T" + toolFormat.format(0);
        }
      }
      writeBlock(gFormat.format(0), gFormat.format(53), ("Z#" + ((currentSection.spindle == SPINDLE_SECONDARY) ? zSubHomeParameter : zHomeParameter)));
      writeBlock( "T" + toolFormat.format(tool.number) + conditional(tool.productId, "." + tool.productId.replace(".", "")), nextool, mFormat.format(6));
    } else {
      writeBlock(gFormat.format(0), gFormat.format(53), ("Z#" + ((currentSection.spindle == SPINDLE_SECONDARY) ? zSubHomeParameter : zHomeParameter)));
      writeBlock( "T" + toolFormat.format(tool.number) + conditional(tool.productId, "." + tool.productId.replace(".", "")), nextool, mFormat.format(6));
    }

    if (tool.comment) {
      writeComment(tool.comment);
    }
    gAbsIncModal.reset();
    writeBlock(gMotionModal.format(0), gAbsIncModal.format(90), getCode("CONSTANT_SURFACE_SPEED_OFF"));
    writeBlock(gFormat.format(40), gFormat.format(49), gFormat.format(80), gFormat.format(67), gRotationModal.format(69));

    if (!machineState.spindlesAreAttached) {
      writeRetract(X, Y);
      writeRetract(Z);
    } else {
      writeRetract(X, Y);
      forceABC();
      writeBlock(gFormat.format(0), gFormat.format(53), bOutput.format(0), ("Z#" + ((currentSection.spindle == SPINDLE_SECONDARY) ? zSubHomeParameter : zHomeParameter)));
    }
  }
  /** Handle multiple turrets. */
  if (gotMultiTurret) {
    var turret = tool.turret;
    if (turret == 0) {
      warning(localize("Turret has not been specified. Using Turret 1 as default."));
      turret = 1; // upper turret as default
    }
    // if (turret != machineState.currentTurret && !isFirstSection()) {
    if (turret != machineState.currentTurret) {
      // change of turret
      setCoolant(COOLANT_OFF, machineState.currentTurret);
    }
    switch (turret) {
    case 1:
      writeBlock(gFormat.format(109), "L1");
      break;
    case 2:
      writeBlock(gFormat.format(109), "L2");
      break;
    default:
      error(localize("Turret is not supported."));
      return;
    }
    machineState.currentTurret = turret;
  }

  setRadiusDiameterMode(insertToolCall);

  // invert axes for secondary spindle
  if (getSpindle(PART) == SPINDLE_SUB) {
    invertAxes(true, false); // polar mode has not been enabled yet
  }
  if (true) {
    switch (currentSection.spindle) {
    case SPINDLE_PRIMARY: // main spindle
      if (gotSecondarySpindle) {
        writeBlock(mFormat.format(901));
      }
      break;
    case SPINDLE_SECONDARY: // sub spindle
      writeBlock(mFormat.format(902));
      break;
    }
  }

  cAxisEngageModal.reset();
  if (machineState.isTurningOperation || machineState.axialCenterDrilling) {
    writeBlock(conditional(machineState.cAxisIsEngaged || machineState.cAxisIsEngaged == undefined), getCode("DISABLE_C_AXIS"));
  } else { // milling
    writeBlock(conditional(!machineState.cAxisIsEngaged || machineState.cAxisIsEngaged == undefined), getCode("ENABLE_C_AXIS"));
  }

  if ((currentSection.feedMode == FEED_PER_REVOLUTION) || machineState.tapping || machineState.axialCenterDrilling) {
    writeBlock(getCode("FEED_MODE_UNIT_REV")); // mm/rev
  } else {
    writeBlock(getCode("FEED_MODE_UNIT_MIN")); // mm/min
  }

  if (getProperty("useTailStock")) {
    if (machineState.axialCenterDrilling || (currentSection.spindle == SPINDLE_SECONDARY) ||
     (machineState.liveToolIsActive && (getMachiningDirection(currentSection) == MACHINING_DIRECTION_AXIAL))) {
      if (currentSection.tailstock) {
        warning(localize("Tail stock is not supported for secondary spindle or Z-axis milling."));
      }
      if (machineState.tailstockIsActive) {
        writeBlock(getCode("TAILSTOCK_OFF"));
        writeBlock(mFormat.format(232), formatComment("RETURN TAILSTOCK TO HOME POSITION"));
      }
    } else {
      writeBlock(currentSection.tailstock ? getCode("TAILSTOCK_ON") : getCode("TAILSTOCK_OFF"));
      if (!machineState.tailstockIsActive) {
        writeBlock(mFormat.format(232), formatComment("RETURN TAILSTOCK TO HOME POSITION"));
      }
    }
  }

  // wcs
  if (insertToolCall) { // force work offset when changing tool
    currentWorkOffset = undefined;
  }

  if (currentSection.workOffset != currentWorkOffset) {
    writeBlock(currentSection.wcs);
    currentWorkOffset = currentSection.workOffset;
  }

  /*
  if (gotYAxis) {
    writeBlock(gMotionModal.format(0), "Y" + yFormat.format(0));
    yOutput.reset();
  }
*/

  // Activate part catcher for part cutoff section
  if (getProperty("usePartCatcher") && partCutoff && currentSection.partCatcher) {
    engagePartCatcher(true);
  }

  if (getProperty("useParametricFeed") &&
      hasParameter("operation-strategy") &&
      (getParameter("operation-strategy") != "drill") && // legacy
      !(currentSection.hasAnyCycle && currentSection.hasAnyCycle())) {
    if (!insertToolCall &&
        activeMovements &&
        (getCurrentSectionId() > 0) &&
        (getPreviousSection().getPatternId() == currentSection.getPatternId()) && (currentSection.getPatternId() != 0)) {
      // use the current feeds
    } else {
      initializeActiveFeeds();
    }
  } else {
    activeMovements = undefined;
  }

  gMotionModal.reset();

  var abc;
  cancelTransformation();
  if (machineConfiguration.isMultiAxisConfiguration()) {
    if (machineState.isTurningOperation || machineState.axialCenterDrilling) { // turning toolpath
      if (gotBAxis) {
        abc = machineState.bAxisOrientationTurning;
        if (insertToolCall || abcFormat.areDifferent(abc.y, previousBAxisOrientationTurning.y)) {
          writeBlock(getCode("UNCLAMP_B_AXIS")); // B-axis
          writeBlock(gMotionModal.format(0), gFormat.format(53), "B" + abcFormat.format(abc.y));
          // writeBlock(getCode("CLAMP_B_AXIS")); // B-axis
        }
      } else {
        setRotation(currentSection.workPlane);
      }
    } else { // milling toolpath
      if (currentSection.isMultiAxis() && useTCPC) {
        forceWorkPlane();
        onCommand(COMMAND_UNLOCK_MULTI_AXIS);
      } else {
        if (useMultiAxisFeatures) {
          if (currentSection.spindle == SPINDLE_PRIMARY) {
            abc = currentSection.workPlane.getEuler2(EULER_ZXZ_R);
          } else {
            var orientation = currentSection.workPlane;
            orientation = new Matrix(orientation.getRight(), orientation.getUp().getNegated(), orientation.getForward().getNegated());
            abc = orientation.getEuler2(EULER_ZXZ_R);
            abc = new Vector(-abc.x, abc.y, -abc.z); // needed for secondary spindle
          }
        } else {
          if (!useTCPC && currentSection.isMultiAxis()) {
            //For machines without TCP Option
            abc = currentSection.getInitialToolAxisABC();
            var mappedWorkplane = machineConfiguration.getOrientation(new Vector(0, -abc.y, 0));
            setRotation(mappedWorkplane);
          } else {
            abc = getWorkPlaneMachineABC(currentSection, currentSection.workPlane);
          }
        }
        if (gotBAxis) {
          if (insertToolCall) {
            bOutput.format(0); // B-axis always moves to 0 at tool change
          }
          setWorkPlane(abc);
        }
      }
    }
  } else { // pure 3D
    var remaining = currentSection.workPlane;
    if (!isSameDirection(remaining.forward, new Vector(0, 0, 1))) {
      error(localize("Tool orientation is not supported by the CNC machine."));
      return;
    }
    setRotation(remaining);
  }
  var forceRPMMode = false;
  var spindleChange = tool.type != TOOL_PROBE &&
    (insertToolCall || forceSpindleSpeed || isSpindleSpeedDifferent() || newSpindle);
  if (spindleChange) {
    forceSpindleSpeed = false;
    if (machineState.isTurningOperation || machineState.axialCenterDrilling) {
      if (spindleSpeed > getProperty("maximumSpindleSpeed")) {
        warning(subst(localize("Spindle speed exceeds maximum value for operation \"%1\"."), getOperationComment()));
      }
    } else {
      if (spindleSpeed > maximumSpindleSpeedLive) {
        warning(subst(localize("Spindle speed exceeds maximum value for operation \"%1\"."), getOperationComment()));
      }
    }
    forceRPMMode = (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED);
    startSpindle(true, getFramePosition(currentSection.getInitialPosition()));
  }
  forceXYZ();

  if (abc !== undefined) {
    if (!currentSection.isMultiAxis()) {
      cOutput.format(abc.z); // make C current - we do not want to output here
    }
  }
  gMotionModal.reset();

  /*
  if (!retracted) {
    // TAG: need to retract along X or Z
    if (getCurrentPosition().z < initialPosition.z) {
      writeBlock(gMotionModal.format(0), zOutput.format(initialPosition.z));
    }
  }
*/

  var initialPosition = getFramePosition(currentSection.getInitialPosition());
  if (insertToolCall || retracted) {
    gPlaneModal.reset();
    gFeedModeModal.reset();
  }
  // Check operation type with connected spindles
  if (machineState.spindlesAreAttached) {
    if (machineState.axialCenterDrilling || (getSpindle(PART) == SPINDLE_SUB) ||
        (getParameter("operation-strategy") == "turningFace") ||
        ((getSpindle(TOOL) == SPINDLE_LIVE) && (getMachiningDirection(currentSection) == MACHINING_DIRECTION_AXIAL))) {
      error(localize("Illegal cutting operation programmed when spindles are synchronized."));
      return;
    }
  }
  // assumes a Head configuration uses TCP on a Fanuc controller
  var offsetCode = 43;
  if (currentSection.isMultiAxis() && useTCPC) {
    if (machineConfiguration.isMultiAxisConfiguration() /* && (currentSection.getOptimizedTCPMode() == 0)*/) {
      offsetCode = 43.4;
    } else if (!machineConfiguration.isMultiAxisConfiguration()) {
      offsetCode = 43.5;
    }
  }
  if (getProperty("useFixedOffset")) {
    var offset = "H#3020";
  } else {
    var offset = "H" + (tool.isTurningTool() ? tool.compensationOffset : tool.lengthOffset);
  }
  if (currentSection.isMultiAxis() && useTCPC) {
    // turn
    var abc;
    forceABC();
    if (currentSection.isOptimizedForMachine()) {
      abc = currentSection.getInitialToolAxisABC();
      writeBlock(
        gMotionModal.format(0), gAbsIncModal.format(90),
        aOutput.format(abc.x), bOutput.format(abc.y), cOutput.format(abc.z)
      );
      previousABC = abc;
    }
    writeBlock(gMotionModal.format(0), gFormat.format(offsetCode), offset, xOutput.format(initialPosition.x), yOutput.format(initialPosition.y), zOutput.format(initialPosition.z), bOutput.format(abc.y));
  } else {
    if (insertToolCall || retracted || newWorkPlane || newWorkOffset || newSpindle) {
      gPlaneModal.reset();
      gMotionModal.reset();
      if (machineState.useXZCMode) {
        writeBlock(gPlaneModal.format(getG17Code()));
        cOutput.reset();
        writeBlock(cOutput.format(getC(initialPosition.x, initialPosition.y)));
        writeBlock(gMotionModal.format(0), gFormat.format(offsetCode), xOutput.format(getModulus(initialPosition.x, initialPosition.y)), conditional(gotYAxis, yOutput.format(0)), zOutput.format(initialPosition.z), offset);
      } else {
        if (machineState.usePolarMode) {
          writeBlock(gMotionModal.format(0), gFormat.format(offsetCode), xOutput.format(getModulus(initialPosition.x, initialPosition.y)), conditional(gotYAxis, yOutput.format(0)), zOutput.format(initialPosition.z), offset);
        } else if (machineState.isTurningOperation || machineState.axialCenterDrilling) { //Turning
          writeBlock(gPlaneModal.format(18));
          writeBlock(gMotionModal.format(0), gFormat.format(offsetCode), "P1", zOutput.format(initialPosition.z), offset);
          writeBlock(xOutput.format(initialPosition.x), yOutput.format(initialPosition.y));
        } else {
          writeBlock(gPlaneModal.format(getG17Code()));
          if (!machineState.spindlesAreAttached) {
            writeBlock(gMotionModal.format(0), gFormat.format(offsetCode), xOutput.format(initialPosition.x), yOutput.format(initialPosition.y), zOutput.format(initialPosition.z), offset);
          } else {
            writeBlock(gMotionModal.format(0), (currentSection.spindle == SPINDLE_PRIMARY ? "C" : "U") + abcFormat.format(abc.z));
            writeBlock(
              gMotionModal.format(0), gFormat.format(offsetCode), xOutput.format(initialPosition.x), yOutput.format(initialPosition.y), zOutput.format(initialPosition.z),
              conditional(machineConfiguration.isMachineCoordinate(0), "A" + abcFormat.format(abc.x)),
              conditional(machineConfiguration.isMachineCoordinate(1), "B" + abcFormat.format(abc.y)),
              offset
            );
            onCommand(COMMAND_LOCK_MULTI_AXIS);
          }
        }
      }
    } else if ((machineState.useXZCMode || machineState.usePolarMode) && yAxisWasEnabled) {
      writeBlock(currentSection.spindle == SPINDLE_PRIMARY ? getCode("UNCLAMP_PRIMARY_SPINDLE") : getCode("UNCLAMP_SECONDARY_SPINDLE")); // C-axis
      if (gotYAxis && yOutput.isEnabled()) {
        writeBlock(gMotionModal.format(0), yOutput.format(0));
      }
    }
  }

  // enable SFM spindle speed
  if (forceRPMMode) {
    startSpindle(false);
  }

  // set coolant after we have positioned at Z
  setCoolant(tool.coolant, machineState.currentTurret);

  if (writeDebug) { // DEBUG
    for (var key in machineState) {
      writeComment(key + " = " + machineState[key]);
    }
    // writeln((getMachineConfigurationAsText(machineConfiguration)));
  }

  //manual NC useSmoothing;
  if (useSmoothing) {
    if ((currentSection.getType() == TYPE_MILLING) &&
        hasParameter("operation-strategy") && (getParameter("operation-strategy") != "drill")) {
      setSmoothing(true);
    } else {
      setSmoothing(false);
    }
  }

  if (getProperty("useG61")) {
    if ((currentSection.getType() == TYPE_MILLING) && hasParameter("operation-strategy") && (getParameter("operation-strategy") != "drill")) {
      setGeometryComp(true);
    } else {
      setGeometryComp(false);
    }
  }
  if (machineState.usePolarMode) {
    setPolarMode(true); // enable polar interpolation mode
  }

  previousSpindle = tempSpindle;
  previousPartSpindle = tempPartSpindle;
  previousBAxisOrientationTurning = new Vector(machineState.bAxisOrientationTurning);
  activeSpindle = tempSpindle;
  retracted = false;
}

/** Returns true if the toolpath fits within the machine XY limits for the given C orientation. */
function doesToolpathFitInXYRange(abc) {
  var xxFormat = createFormat({inherit:xFormat, scale:Math.abs(xFormat.getScale())});
  var yyFormat = createFormat({inherit:yFormat, scale:Math.abs(yFormat.getScale())});
  // var xMin = xAxisMinimum * Math.abs(xFormat.getScale());
  // var yMin = yAxisMinimum * Math.abs(yFormat.getScale());
  // var yMax = yAxisMaximum * Math.abs(yFormat.getScale());
  var xMin = xxFormat.getResultingValue(xAxisMinimum);
  var yMin = yyFormat.getResultingValue(yAxisMinimum);
  var yMax = yyFormat.getResultingValue(yAxisMaximum);
  var c = 0;
  if (abc) {
    c = abc.z;
  }
  if (Vector.dot(machineConfiguration.getAxisU().getAxis(), new Vector(0, 0, 1)) != 0) {
    c *= (machineConfiguration.getAxisU().getAxis().getCoordinate(2) >= 0) ? 1 : -1; // C-axis is the U-axis
  } else {
    c *= (machineConfiguration.getAxisV().getAxis().getCoordinate(2) >= 0) ? 1 : -1; // C-axis is the V-axis
  }

  var dx = new Vector(Math.cos(c), Math.sin(c), 0);
  var dy = new Vector(Math.cos(c + Math.PI / 2), Math.sin(c + Math.PI / 2), 0);

  if (currentSection.getGlobalRange) {
    var xRange = currentSection.getGlobalRange(dx);
    var yRange = currentSection.getGlobalRange(dy);

    if (writeDebug) { // DEBUG
      writeComment(
        "toolpath X minimum= " + xxFormat.format(xRange[0]) + ", " + "Limit= " + xMin + ", " +
        "within range= " + (xxFormat.getResultingValue(xRange[0]) >= xMin)
      );
      writeComment(
        "toolpath Y minimum= " + yyFormat.getResultingValue(yRange[0]) + ", " + "Limit= " + yMin + ", " +
        "within range= " + (yyFormat.getResultingValue(yRange[0]) >= yMin)
      );
      writeComment(
        "toolpath Y maximum= " + (yyFormat.getResultingValue(yRange[1]) + ", " + "Limit= " + yMax) + ", " +
        "within range= " + (yyFormat.getResultingValue(yRange[1]) <= yMax)
      );
      writeln("");
    }

    if (getMachiningDirection(currentSection) == MACHINING_DIRECTION_RADIAL) { // G19 plane
      if ((yyFormat.getResultingValue(yRange[0]) >= yMin) &&
          (yyFormat.getResultingValue(yRange[1]) <= yMax)) {
        return true; // toolpath does fit in XY range
      } else {
        return false; // toolpath does not fit in XY range
      }
    } else { // G17 plane
      if ((xxFormat.getResultingValue(xRange[0]) >= xMin) &&
          (yyFormat.getResultingValue(yRange[0]) >= yMin) &&
          (yyFormat.getResultingValue(yRange[1]) <= yMax)) {
        return true; // toolpath does fit in XY range
      } else {
        return false; // toolpath does not fit in XY range
      }
    }
  } else {
    if (revision < 40000) {
      warning(localize("Please update to the latest release to allow XY linear interpolation instead of polar interpolation."));
    }
    return false; // for older versions without the getGlobalRange() function
  }
}

var MACHINING_DIRECTION_AXIAL = 0;
var MACHINING_DIRECTION_RADIAL = 1;
var MACHINING_DIRECTION_INDEXING = 2;

function getMachiningDirection(section) {
  var forward = section.isMultiAxis() ? section.getGlobalInitialToolAxis() : section.workPlane.forward;
  if (isSameDirection(forward, new Vector(0, 0, 1))) {
    machineState.machiningDirection = MACHINING_DIRECTION_AXIAL;
    return MACHINING_DIRECTION_AXIAL;
  } else if (Vector.dot(forward, new Vector(0, 0, 1)) < 1e-7) {
    machineState.machiningDirection = MACHINING_DIRECTION_RADIAL;
    return MACHINING_DIRECTION_RADIAL;
  } else {
    machineState.machiningDirection = MACHINING_DIRECTION_INDEXING;
    return MACHINING_DIRECTION_INDEXING;
  }
}

function updateMachiningMode(section) {
  machineState.axialCenterDrilling = false; // reset
  machineState.usePolarMode = false; // reset
  machineState.useXZCMode = false; // reset
  machineState.bAxisOrientationTurning = new Vector(0, 0, 0);
  machineState.isTurningOperation = (section.getType() == TYPE_TURNING);
  machineState.tapping = section.hasParameter("operation:cycleType") &&
    ((section.getParameter("operation:cycleType") == "tapping") ||
    (section.getParameter("operation:cycleType") == "right-tapping") ||
    (section.getParameter("operation:cycleType") == "left-tapping") ||
    (section.getParameter("operation:cycleType") == "tapping-with-chip-breaking"));

  if ((section.getType() == TYPE_MILLING) && !section.isMultiAxis()) {
    if (getMachiningDirection(section) == MACHINING_DIRECTION_AXIAL) {
      if (section.hasParameter("operation-strategy") && (section.getParameter("operation-strategy") == "drill")) {
        // drilling axial
        if ((section.getNumberOfCyclePoints() == 1) &&
            !xFormat.isSignificant(getGlobalPosition(section.getInitialPosition()).x) &&
            !yFormat.isSignificant(getGlobalPosition(section.getInitialPosition()).y) &&
            (spatialFormat.format(section.getFinalPosition().x) == 0) &&
            !doesCannedCycleIncludeYAxisMotion(section)) { // catch drill issue for old versions
          // single hole on XY center
          if (section.getTool().isLiveTool && section.getTool().isLiveTool()) {
            // use live tool
          } else {
            // use main spindle for axialCenterDrilling
            machineState.axialCenterDrilling = true;
            if (gotBAxis) {
              machineState.bAxisOrientationTurning = getBAxisOrientationTurning(section);
            }
          }
        } else {
          // several holes not on XY center
          bestABCIndex = getBestABCIndex(section);
          if (getProperty("useYAxisForDrilling") && (bestABCIndex != undefined) && !doesCannedCycleIncludeYAxisMotion(section)) {
            // use XYZ-mode
          } else { // use XZC mode
            machineState.useXZCMode = true;
            bestABCIndex = undefined;
          }
        }
      } else { // milling
        if (forcePolarMode) {
          machineState.usePolarMode = true;
        } else if (forceXZCMode) {
          machineState.useXZCMode = true;
        } else {
          fitFlag = false;
          bestABCIndex = undefined;
          for (var i = 0; i < 10; ++i) {
            fitFlag = doesToolpathFitInXYRange(getBestABC(section, section.workPlane, i));
            if (fitFlag) {
              bestABCIndex = i;
              break;
            }
          }
          if (!fitFlag) { // does not fit, set polar/XZC mode
            if (gotPolarInterpolation) {
              machineState.usePolarMode = true;
            } else {
              machineState.useXZCMode = true;
            }
          }
        }
      }
    } else if (getMachiningDirection(section) == MACHINING_DIRECTION_RADIAL) { // G19 plane
      if (!gotYAxis) {
        if (!section.isMultiAxis() && (!doesToolpathFitInXYRange(machineConfiguration.getABC(section.workPlane)) || doesCannedCycleIncludeYAxisMotion(section))) {
          error(subst(localize("Y-axis motion is not possible without a Y-axis for operation \"%1\"."), getOperationComment()));
          return;
        }
      } else {
        if (!doesToolpathFitInXYRange(machineConfiguration.getABC(section.workPlane)) || forceXZCMode) {
          error(subst(localize("Toolpath exceeds the maximum ranges for operation \"%1\"."), getOperationComment()));
          return;
        }
      }
      // C-coordinates come from setWorkPlane or is within a multi axis operation, we cannot use the C-axis for non wrapped toolpathes (only multiaxis works, all others have to be into XY range)
    } else {
      // useXZCMode & usePolarMode is only supported for axial machining, keep false
    }
  } else { // turning or multi axis, keep false
    if (machineState.isTurningOperation && gotBAxis) {
      machineState.bAxisOrientationTurning = getBAxisOrientationTurning(section);
    }
  }

  if (machineState.axialCenterDrilling) {
    cOutput.disable();
  } else {
    cOutput.enable();
  }

  var checksum = 0;
  checksum += machineState.usePolarMode ? 1 : 0;
  checksum += machineState.useXZCMode ? 1 : 0;
  checksum += machineState.axialCenterDrilling ? 1 : 0;
  validate(checksum <= 1, localize("Internal post processor error."));
}

function doesCannedCycleIncludeYAxisMotion(section) {
  // these cycles have Y axis motions which are not detected by getGlobalRange()
  var hasYMotion = false;
  if (section.hasParameter("operation:strategy") && (section.getParameter("operation:strategy") == "drill")) {
    switch (section.getParameter("operation:cycleType")) {
    case "thread-milling":
    case "bore-milling":
    case "circular-pocket-milling":
      hasYMotion = true; // toolpath includes Y-axis motion
      break;
    case "back-boring":
    case "fine-boring":
      var shift = getParameter("operation:boringShift");
      if (shift != spatialFormat.format(0)) {
        hasYMotion = true; // toolpath includes Y-axis motion
      }
      break;
    default:
      hasYMotion = false; // all other cycles don't have Y-axis motion
    }
  }
  return hasYMotion;
}

function getOperationComment() {
  var operationComment = hasParameter("operation-comment") && getParameter("operation-comment");
  return operationComment;
}

var radiusMode = undefined;
function setRadiusDiameterMode(force) {
  var mode = !(machineState.isTurningOperation || machineState.axialCenterDrilling);
  if (mode != radiusMode || force) {
    if (!mode) { // diameter mode
      writeBlock(gFormat.format(10.9), "X1"); // diameter input mode
      radiusMode = false;
    } else { // radius mode
      writeBlock(gFormat.format(10.9), "X0"); // radius input mode
      radiusMode = true;
    }
  }
  if (!radiusMode) {
    xFormat.setScale(2); // diameter mode
  } else {
    if (currentSection.spindle == SPINDLE_PRIMARY) {
      xFormat.setScale(1);
    } else {
      xFormat.setScale(machineState.useXZCMode || machineState.usePolarMode ? -1 : 1);
    }
  }
  xOutput = createVariable({prefix:"X"}, xFormat);
}

function setPolarMode(activate) {
  if (activate) {
     // command for polar interpolation

 if (getSpindle(PART) == SPINDLE_SUB) {
    cOutput.reset();
    var initialPosition = getFramePosition(currentSection.getInitialPosition());
    gPlaneModal.reset();
    writeBlock(gMotionModal.format(0), xOutput.format(getModulus(initialPosition.x, initialPosition.y)), cOutput.format(0));
    writeBlock("G91");
    writeBlock(gPlaneModal.format(getG17Code()), "XU");
    writeBlock("G90");
    writeBlock(getCode("POLAR_INTERPOLATION_ON")); // command for polar interpolation
      invertAxes(true, true);
      xFormat.setScale(1); // radius mode
    } else {
        cOutput.reset();
        var initialPosition = getFramePosition(currentSection.getInitialPosition());
        gPlaneModal.reset();
        writeBlock(gMotionModal.format(0), xOutput.format(getModulus(initialPosition.x, initialPosition.y)), cOutput.format(0));
        writeBlock("G91");
        writeBlock(gPlaneModal.format(getG17Code()), "XC");
        writeBlock("G90");
        writeBlock(getCode("POLAR_INTERPOLATION_ON"));

    
      yOutput = createVariable({prefix:"C"}, yFormat);
      yOutput.enable(); // required for G12.1
      cOutput.disable();
      xFormat.setScale(1); // radius mode
    }
    xOutput = createVariable({prefix:"X"}, xFormat);
  } else {
    writeBlock(getCode("POLAR_INTERPOLATION_OFF"));
    yOutput.setPrefix("Y");
    if (!gotYAxis) {
      yOutput.disable();
    }
  }
}

function onDwell(seconds) {
  if (seconds > 99999.999) {
    warning(localize("Dwelling time is out of range."));
  }
  milliseconds = clamp(1, seconds * 1000, 99999999);
  writeBlock(gFeedModeModal.format(94), gFormat.format(4), "P" + milliFormat.format(milliseconds));
}

var pendingRadiusCompensation = -1;

function onRadiusCompensation() {
  pendingRadiusCompensation = radiusCompensation;
}

function getCompensationPlane(abc, returnCode, outputPlane) {
  var plane;
  if (machineState.isTurningOperation) {
    plane = PLANE_ZX;
  } else if (machineState.usePolarMode) {
    plane = PLANE_XY;
  } else {
    var found = false;
    if (useTCPC) {
      plane = PLANE_XY;
      found = true;
    }
    if (!found) {
      if (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, 1))) {
        plane = PLANE_XY;
      } else if (Vector.dot(currentSection.workPlane.forward, new Vector(0, 0, 1)) < 1e-7) {
        plane = PLANE_YZ;
      } else {
        if (returnCode) {
          if (getMachiningDirection(currentSection) == MACHINING_DIRECTION_AXIAL) {
            plane = PLANE_XY;
          } else {
            plane = PLANE_ZX;
          }
        } else {
          plane = -1;
          if (outputPlane) {
            error(localize("Tool orientation is not supported for radius compensation."));
            return -1;
          }
        }
      }
    }
  }
  var code = plane == -1 ? -1 : (plane == PLANE_XY ? getG17Code() : (plane == PLANE_ZX ? 18 : 19));
  // if (outputPlane) {
  //   writeBlock(gPlaneModal.format(code));
  // }
  // return returnCode ? code : plane;
}

var resetFeed = false;

function getHighfeedrate(radius) {
  if (currentSection.feedMode == FEED_PER_REVOLUTION) {
    if (toDeg(radius) <= 0) {
      radius = toPreciseUnit(0.1, MM);
    }
    var rpm = spindleSpeed; // rev/min
    if (currentSection.getTool().getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
      var O = 2 * Math.PI * radius; // in/rev
      rpm = tool.surfaceSpeed / O; // in/min div in/rev => rev/min
    }
    return highFeedrate / rpm; // in/min div rev/min => in/rev
  }
  return highFeedrate;
}

function onRapid(_x, _y, _z) {
  if (machineState.useXZCMode) {
    var start = getCurrentPosition();
    var dxy = getModulus(_x - start.x, _y - start.y);
    if (true || (dxy < getTolerance())) {
      var x = xOutput.format(getModulus(_x, _y));
      var currentC = getCWithinRange(_x, _y, cOutput.getCurrent());
      var c = cOutput.format(currentC);
      var z = zOutput.format(_z);
      if (pendingRadiusCompensation >= 0) {
        error(localize("Radius compensation mode cannot be changed at rapid traversal."));
        return;
      }
      if (forceRewind) {
        rewindTable(start, _z, cOutput.getCurrent(), highFeedrate, false);
      }
      writeBlock(gMotionModal.format(0), x, c, z);
      previousABC.setZ(currentC);
      forceFeed();
      return;
    }

    onExpandedLinear(_x, _y, _z, highFeedrate);
    return;
  }

  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      error(localize("Radius compensation mode cannot be changed at rapid traversal."));
      return;
    }
    if (!getProperty("useG0Polar") && machineState.usePolarMode) {
      var highFeed = toPreciseUnit(1500, MM);
      writeBlock(gMotionModal.format(1), x, y, z, getFeed(highFeed));
    } else {
      writeBlock(gMotionModal.format(0), x, y, z);
      forceFeed();
      resetFeed = false;
    }
  }
}

/** Calculate the distance of a point to a line segment. */
function pointLineDistance(startPt, endPt, testPt) {
  var delta = Vector.diff(endPt, startPt);
  distance = Math.abs(delta.y * testPt.x - delta.x * testPt.y + endPt.x * startPt.y - endPt.y * startPt.x) /
    Math.sqrt(delta.y * delta.y + delta.x * delta.x); // distance from line to point
  if (distance < 1e-4) { // make sure point is in line segment
    var moveLength = Vector.diff(endPt, startPt).length;
    var startLength = Vector.diff(startPt, testPt).length;
    var endLength = Vector.diff(endPt, testPt).length;
    if ((startLength > moveLength) || (endLength > moveLength)) {
      distance = Math.min(startLength, endLength);
    }
  }
  return distance;
}

/** Refine segment for XC mapping. */
function refineSegmentXC(startX, startC, endX, endC, maximumDistance) {
  var rotary = machineConfiguration.getAxisU(); // C-axis
  var startPt = rotary.getAxisRotation(startC).multiply(new Vector(startX, 0, 0));
  var endPt = rotary.getAxisRotation(endC).multiply(new Vector(endX, 0, 0));

  var testX = startX + (endX - startX) / 2; // interpolate as the machine
  var testC = startC + (endC - startC) / 2;
  var testPt = rotary.getAxisRotation(testC).multiply(new Vector(testX, 0, 0));

  var delta = Vector.diff(endPt, startPt);
  var distf = pointLineDistance(startPt, endPt, testPt);

  if (distf > maximumDistance) {
    return false; // out of tolerance
  } else {
    return true;
  }
}

function rewindTable(startXYZ, currentZ, rewindC, feed, retract) {
  if (!cFormat.areDifferent(rewindC, cOutput.getCurrent())) {
    error(localize("Rewind position not found."));
    return;
  }
  writeComment("Rewind of C-axis, make sure retracting is possible.");
  onCommand(COMMAND_STOP);
  if (retract) {
    writeBlock(gMotionModal.format(1), zOutput.format(currentSection.getInitialPosition().z), getFeed(feed));
  }
  writeBlock(getCode("DISABLE_C_AXIS"));
  writeBlock(getCode("ENABLE_C_AXIS"));
  gMotionModal.reset();
  xOutput.reset();
  startSpindle(false);
  if (retract) {
    var x = getModulus(startXYZ.x, startXYZ.y);
    if (getProperty("rapidRewinds")) {
      writeBlock(gMotionModal.format(1), xOutput.format(x), getFeed(highFeedrate));
      writeBlock(gMotionModal.format(0), cOutput.format(rewindC));
    } else {
      writeBlock(gMotionModal.format(1), xOutput.format(x), cOutput.format(rewindC), getFeed(highFeedrate));
    }
    writeBlock(gMotionModal.format(1), zOutput.format(startXYZ.z), getFeed(feed));
  }
  setCoolant(tool.coolant, machineState.currentTurret);
  forceRewind = false;
  writeComment("End of rewind");
}

function onLinear(_x, _y, _z, feed) {
  if (machineState.useXZCMode) {
    if (pendingRadiusCompensation >= 0) {
      error(subst(localize("Radius compensation is not supported by using XZC mode for operation \"%1\"."), getOperationComment()));
      return;
    }
    if (maximumCircularSweep > toRad(179)) {
      error(localize("Maximum circular sweep must be below 179 degrees."));
      return;
    }

    var localTolerance = getTolerance() / 4;

    var startXYZ = getCurrentPosition();
    var startX = getModulus(startXYZ.x, startXYZ.y);
    var startZ = startXYZ.z;
    var startC = cOutput.getCurrent();

    var endXYZ = new Vector(_x, _y, _z);
    var endX = getModulus(endXYZ.x, endXYZ.y);
    var endZ = endXYZ.z;
    var endC = getCWithinRange(endXYZ.x, endXYZ.y, startC);

    var currentXYZ = endXYZ; var currentX = endX; var currentZ = endZ; var currentC = endC;
    var centerXYZ = machineConfiguration.getAxisU().getOffset();

    var refined = true;
    var crossingRotary = false;
    forceOptimized = false; // tool tip is provided to DPM calculations
    while (refined) { // stop if we dont refine
      // check if we cross center of rotary axis
      var _start = new Vector(startXYZ.x, startXYZ.y, 0);
      var _current = new Vector(currentXYZ.x, currentXYZ.y, 0);
      var _center = new Vector(centerXYZ.x, centerXYZ.y, 0);
      if ((xFormat.getResultingValue(pointLineDistance(_start, _current, _center)) == 0) &&
          (xFormat.getResultingValue(Vector.diff(_start, _center).length) != 0) &&
          (xFormat.getResultingValue(Vector.diff(_current, _center).length) != 0)) {
        var ratio = Vector.diff(_center, _start).length / Vector.diff(_current, _start).length;
        currentXYZ = centerXYZ;
        currentXYZ.z = startZ + (endZ - startZ) * ratio;
        currentX = getModulus(currentXYZ.x, currentXYZ.y);
        currentZ = currentXYZ.z;
        currentC = startC;
        crossingRotary = true;
      } else { // check if move is out of tolerance
        refined = false;
        while (!refineSegmentXC(startX, startC, currentX, currentC, localTolerance)) { // move is out of tolerance
          refined = true;
          currentXYZ = Vector.lerp(startXYZ, currentXYZ, 0.75);
          currentX = getModulus(currentXYZ.x, currentXYZ.y);
          currentZ = currentXYZ.z;
          currentC = getCWithinRange(currentXYZ.x, currentXYZ.y, startC);
          if (Vector.diff(startXYZ, currentXYZ).length < 1e-5) { // back to start point, output error
            if (forceRewind) {
              break;
            } else {
              warning(localize("Linear move cannot be mapped to rotary XZC motion."));
              break;
            }
          }
        }
      }

      currentC = getCWithinRange(currentXYZ.x, currentXYZ.y, startC);
      if (forceRewind) {
        var rewindC = getCClosest(startXYZ.x, startXYZ.y, currentC);
        xOutput.reset(); // force X for repositioning
        rewindTable(startXYZ, currentZ, rewindC, feed, true);
        previousABC.setZ(rewindC);
      }
      var x = xOutput.format(currentX);
      var c = cOutput.format(currentC);
      var z = zOutput.format(currentZ);
      if (x || c || z) {
        writeBlock(gMotionModal.format(1), x, c, z, getFeed(feed));
      }
      setCurrentPosition(currentXYZ);
      previousABC.setZ(currentC);
      if (crossingRotary) {
        writeBlock(gMotionModal.format(1), cOutput.format(endC), getFeed(feed)); // rotate at X0 with endC
        previousABC.setZ(endC);
        forceFeed();
      }
      startX = currentX; startZ = currentZ; startC = crossingRotary ? endC : currentC; startXYZ = currentXYZ; // loop start point
      currentX = endX; currentZ = endZ; currentC = endC; currentXYZ = endXYZ; // loop end point
      crossingRotary = false;
    }
    forceOptimized = undefined;
    return;
  }

  if (isSpeedFeedSynchronizationActive()) {
    resetFeed = true;
    var threadPitch = getParameter("operation:threadPitch");
    var threadsPerInch = 1.0 / threadPitch; // per mm for metric
    writeBlock(gMotionModal.format(32), xOutput.format(_x), yOutput.format(_y), zOutput.format(_z), pitchOutput.format(1 / threadsPerInch));
    return;
  }
  if (resetFeed) {
    resetFeed = false;
    forceFeed();
  }
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var f = ((currentSection.feedMode != FEED_PER_REVOLUTION) && machineState.feedPerRevolution) ? feedOutput.format(feed / spindleSpeed) : getFeed(feed);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      if (machineState.isTurningOperation) {
        writeBlock(gPlaneModal.format(18));
      } else {
        writeBlock(gPlaneModal.format(getG17Code()));
      }

      var plane = getCompensationPlane(previousABC, false, true);
      var mirror = isMirrored(plane) && (machineState.isTurningOperation || machineState.usePolarMode);
      var ccLeft = mirror ? 41 : 42;
      var ccRight = mirror ? 42 : 41;
      switch (radiusCompensation) {
      case RADIUS_COMPENSATION_LEFT:
        writeBlock(
          gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1),
          gFormat.format(ccLeft),
          x, y, z, f
        );
        break;
      case RADIUS_COMPENSATION_RIGHT:
        writeBlock(
          gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1),
          gFormat.format(ccRight),
          x, y, z, f
        );
        break;
      default:
        writeBlock(gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1), gFormat.format(40), x, y, z, f);
      }
    } else {
      writeBlock(gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1), x, y, z, f);
    }
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      forceFeed(); // force feed on next line
    } else {
      writeBlock(gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1), f);
    }
  }
}

function onRapid5D(_x, _y, _z, _a, _b, _c) {
  if (!currentSection.isOptimizedForMachine()) {
    error(localize("Multi-axis motion is not supported for XZC mode."));
    return;
  }
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation mode cannot be changed at rapid traversal."));
    return;
  }

  if (!currentSection.isOptimizedForMachine()) {
    forceXYZ();
  }

  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);

  if (currentSection.isOptimizedForMachine()) {
    var a = aOutput.format(_a);
    var b = bOutput.format(_b);
    var c = cOutput.format(_c);
    writeBlock(gMotionModal.format(0), x, y, z, a, b, c);
  } else {
    var i = spatialFormat.format(_a);
    var j = spatialFormat.format(_b);
    var k = spatialFormat.format(_c);
    writeBlock(gMotionModal.format(0), x, y, z, "I" + i, "J" + j, "K" + k);
  }
  forceFeed();
  previousABC = new Vector(_a, _b, _c);
}

function onLinear5D(_x, _y, _z, _a, _b, _c, feed) {
  if (abcFormat.areDifferent(previousABC.y, _b) && !useTCPC) {
    error(localize("5-axis simultaneous toolpath not supported without TCPC."));
  }

  var tol = getParameter("operation:tolerance", toPreciseUnit(0.001, IN));
  var current = getCurrentPosition();
  var cOnly = !(xFormat.areDifferent(_x, current.x) || yFormat.areDifferent(_y, current.y) || zFormat.areDifferent(_z, current.z) ||
    abcFormat.areDifferent(_a, previousABC.x) || abcFormat.areDifferent(_b, previousABC.y)) && abcFormat.areDifferent(_c, previousABC.z);
  if (currentSection.isOptimizedForMachine() && getProperty("tableAdjust") && cOnly && useTCPC) {
    var axis = machineConfiguration.getAxisByCoordinate(2);
    var radius = Vector.diff(new Vector(_x, _y, 0), new Vector(0, 0, 0)).length;
    var delta = _c - previousABC.z;
    if (delta > Math.PI) {
      delta -= Math.PI * 2;
    } else if (delta < -Math.PI) {
      delta += Math.PI * 2;
    }
    var cosAngle = radius < tol ? 0 : ((radius - tol) / radius);
    var maxAngle = Math.acos(cosAngle) * 2;
    var ratio = maxAngle / Math.abs(delta);
    var ntimes = Math.ceil(1 / ratio);
    if (ntimes > 1) {
      //writeComment("INSERTED " + (ntimes - 1) + " BLOCKS");
      delta /= ntimes;
      for (var i = 1; i < ntimes; ++i) {
        var c = previousABC.z + delta;
        c = axis.remapToRange(c);
        writeLinear5D(_x, _y, _z, _a, _b, c, feed);
      }
    }
  }
  writeLinear5D(_x, _y, _z, _a, _b, _c, feed);
  previousABC = new Vector(_a, _b, _c);
}

function writeLinear5D(_x, _y, _z, _a, _b, _c, feed) {
  if (!currentSection.isOptimizedForMachine()) {
    error(localize("Multi-axis motion is not supported for XZC mode."));
    return;
  }
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for 5-axis move."));
    return;
  }

  if (!currentSection.isOptimizedForMachine()) {
    forceXYZ();
  }

  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);

  if (currentSection.isOptimizedForMachine()) {
    var a = aOutput.format(_a);
    var b = bOutput.format(_b);
    var c = cOutput.format(_c);
    var actualFeed = getMultiaxisFeed(_x, _y, _z, _a, _b, _c, feed);
    var f = getFeed(actualFeed.frn);
    if (x || y || z || a || b || c) {
      writeBlock(gMotionModal.format(1), x, y, z, a, b, c, f);
    } else if (f) {
      if (getNextRecord().isMotion()) { // try not to output feed without motion
        forceFeed(); // force feed on next line
      } else {
        writeBlock(gMotionModal.format(1), f);
      }
    }
  } else {
    var i = spatialFormat.format(_a);
    var j = spatialFormat.format(_b);
    var k = spatialFormat.format(_c);
    var f = getFeed(feed);
    if (x || y || z || i || j || k) {
      writeBlock(gMotionModal.format(1), x, y, z, "I" + i, "J" + j, "K" + k, f);
    } else if (f) {
      if (getNextRecord().isMotion()) { // try not to output feed without motion
        forceFeed(); // force feed on next line
      } else {
        writeBlock(gMotionModal.format(1), f);
      }
    }
  }
}

// Start of multi-axis feedrate logic
/***** Be sure to add 'useInverseTime' to post properties if necessary. *****/
/***** 'inverseTimeOutput' should be defined if Inverse Time feedrates are supported. *****/
/***** 'previousABC' can be added throughout to maintain previous rotary positions. Required for Mill/Turn machines. *****/
/***** 'headOffset' should be defined when a head rotary axis is defined. *****/
/***** The feedrate mode must be included in motion block output (linear, circular, etc.) for Inverse Time feedrate support. *****/
var dpmBPW = unit == MM ? 1.0 : 0.1;// ratio of rotary accuracy to linear accuracy for DPM calculations
var inverseTimeUnits = 1.0; // 1.0 = minutes, 60.0 = seconds
var maxInverseTime = 45000; // maximum value to output for Inverse Time feeds
var maxDPM = 99999; // maximum value to output for DPM feeds
var useInverseTimeFeed = false; // use DPM feeds
var previousDPMFeed = 0; // previously output DPM feed
var dpmFeedToler = 0.5; // tolerance to determine when the DPM feed has changed
var previousABC = new Vector(0, 0, 0); // previous ABC position if maintained in post, don't define if not used
var forceOptimized = undefined; // used to override optimized-for-angles points (XZC-mode)

/** Calculate the multi-axis feedrate number. */
function getMultiaxisFeed(_x, _y, _z, _a, _b, _c, feed) {
  var f = {frn:0, fmode:0};
  if (feed <= 0) {
    error(localize("Feedrate is less than or equal to 0."));
    return f;
  }

  // get unrotated coordinates
  var current = getCurrentPosition();
  var m = getRotation().getTransposed();
  var xyz = m.multiply(new Vector(_x, _y, _z));
  setCurrentPosition(m.multiply(current));

  var length = getMoveLength(xyz.x, xyz.y, xyz.z, _a, _b, _c);
  setCurrentPosition(current);

  if (useInverseTimeFeed) { // inverse time
    f.frn = getInverseTime(length.tool, feed);
    f.fmode = 93;
    feedOutput.reset();
  } else { // degrees per minute
    f.frn = getFeedDPM(length, feed);
    f.fmode = 94;
  }
  return f;
}

/** Returns point optimization mode. */
function getOptimizedMode() {
  if (forceOptimized != undefined) {
    return forceOptimized;
  }
  // return (currentSection.getOptimizedTCPMode() != 0); // TAG:doesn't return correct value
  return true; // always return false for non-TCP based heads
}

/** Calculate the DPM feedrate number. */
function getFeedDPM(_moveLength, _feed) {
  if ((_feed == 0) || (_moveLength.tool < 0.0001) || (toDeg(_moveLength.abcLength) < 0.0005)) {
    previousDPMFeed = 0;
    return _feed;
  }
  var moveTime = _moveLength.tool / _feed;
  if (moveTime == 0) {
    previousDPMFeed = 0;
    return _feed;
  }
  /*writeln("tool length = " + _moveLength.tool);
  writeln("abc length = " + toDeg(_moveLength.abcLength));
  writeln("feed = " + _feed);
  writeln("time = " + moveTime);*/

  var dpmFeed;
  var tcp = ((!getOptimizedMode() || useTCPC) && forceOptimized == undefined);  // set to false for rotary heads
  //writeBlock("test = " + getOptimizedMode());
  if (tcp) { // TCP mode is supported, output feed as FPM
    dpmFeed = _feed;
  } else if (true) { // standard DPM
    dpmFeed = Math.min(toDeg(_moveLength.abcLength) / moveTime, maxDPM);
    if (Math.abs(dpmFeed - previousDPMFeed) < dpmFeedToler) {
      dpmFeed = previousDPMFeed;
    }
  } else if (false) { // combination FPM/DPM
    var length = Math.sqrt(Math.pow(_moveLength.xyzLength, 2.0) + Math.pow((toDeg(_moveLength.abcLength) * dpmBPW), 2.0));
    dpmFeed = Math.min((length / moveTime), maxDPM);
    if (Math.abs(dpmFeed - previousDPMFeed) < dpmFeedToler) {
      dpmFeed = previousDPMFeed;
    }
  } else { // machine specific calculation
    dpmFeed = _feed;
  }
  previousDPMFeed = dpmFeed;
  return dpmFeed;
}

/** Calculate the Inverse time feedrate number. */
function getInverseTime(_length, _feed) {
  var inverseTime;
  if (_length < 1.e-6) { // tool doesn't move
    if (typeof maxInverseTime === "number") {
      inverseTime = maxInverseTime;
    } else {
      inverseTime = 999999;
    }
  } else {
    inverseTime = _feed / _length / inverseTimeUnits;
    if (typeof maxInverseTime === "number") {
      if (inverseTime > maxInverseTime) {
        inverseTime = maxInverseTime;
      }
    }
  }
  return inverseTime;
}

/** Calculate radius for each rotary axis. */
function getRotaryRadii(startTool, endTool, startABC, endABC) {
  var radii = new Vector(0, 0, 0);
  var startRadius;
  var endRadius;
  var axis = new Array(machineConfiguration.getAxisU(), machineConfiguration.getAxisV(), machineConfiguration.getAxisW());
  for (var i = 0; i < 3; ++i) {
    if (axis[i].isEnabled()) {
      var startRadius = getRotaryRadius(axis[i], startTool, startABC);
      var endRadius = getRotaryRadius(axis[i], endTool, endABC);
      radii.setCoordinate(axis[i].getCoordinate(), Math.max(startRadius, endRadius));
    }
  }
  return radii;
}

/** Calculate the distance of the tool position to the center of a rotary axis. */
function getRotaryRadius(axis, toolPosition, abc) {
  if (!axis.isEnabled()) {
    return 0;
  }

  var direction = axis.getEffectiveAxis();
  var normal = direction.getNormalized();
  // calculate the rotary center based on head/table
  var center;
  var radius;
  if (axis.isHead()) {
    var pivot;
    if (typeof headOffset === "number") {
      pivot = headOffset;
    } else {
      pivot = tool.getBodyLength();
    }
    if (axis.getCoordinate() == machineConfiguration.getAxisU().getCoordinate()) { // rider
      center = Vector.sum(toolPosition, Vector.product(machineConfiguration.getDirection(abc), pivot));
      center = Vector.sum(center, axis.getOffset());
      radius = Vector.diff(toolPosition, center).length;
    } else { // carrier
      var angle = abc.getCoordinate(machineConfiguration.getAxisU().getCoordinate());
      radius = Math.abs(pivot * Math.sin(angle));
      radius += axis.getOffset().length;
    }
  } else {
    center = axis.getOffset();
    var d1 = toolPosition.x - center.x;
    var d2 = toolPosition.y - center.y;
    var d3 = toolPosition.z - center.z;
    var radius = Math.sqrt(
      Math.pow((d1 * normal.y) - (d2 * normal.x), 2.0) +
      Math.pow((d2 * normal.z) - (d3 * normal.y), 2.0) +
      Math.pow((d3 * normal.x) - (d1 * normal.z), 2.0)
    );
  }
  return radius;
}

/** Calculate the linear distance based on the rotation of a rotary axis. */
function getRadialDistance(radius, startABC, endABC) {
  // calculate length of radial move
  var delta = Math.abs(endABC - startABC);
  if (delta > Math.PI) {
    delta = 2 * Math.PI - delta;
  }
  var radialLength = (2 * Math.PI * radius) * (delta / (2 * Math.PI));
  return radialLength;
}

/** Calculate tooltip, XYZ, and rotary move lengths. */
function getMoveLength(_x, _y, _z, _a, _b, _c) {
  // get starting and ending positions
  var moveLength = {};
  var startTool;
  var endTool;
  var startXYZ;
  var endXYZ;
  var startABC;
  if (typeof previousABC !== "undefined") {
    startABC = new Vector(previousABC.x, previousABC.y, previousABC.z);
  } else {
    startABC = getCurrentDirection();
  }
  var endABC = new Vector(_a, _b, _c);

  if (!getOptimizedMode()) { // calculate XYZ from tool tip
    startTool = getCurrentPosition();
    endTool = new Vector(_x, _y, _z);
    startXYZ = startTool;
    endXYZ = endTool;

    // adjust points for tables
    if (!machineConfiguration.getTableABC(startABC).isZero() || !machineConfiguration.getTableABC(endABC).isZero()) {
      startXYZ = machineConfiguration.getOrientation(machineConfiguration.getTableABC(startABC)).getTransposed().multiply(startXYZ);
      endXYZ = machineConfiguration.getOrientation(machineConfiguration.getTableABC(endABC)).getTransposed().multiply(endXYZ);
    }

    // adjust points for heads
    if (machineConfiguration.getAxisU().isEnabled() && machineConfiguration.getAxisU().isHead()) {
      if (typeof getOptimizedHeads === "function") { // use post processor function to adjust heads
        startXYZ = getOptimizedHeads(startXYZ.x, startXYZ.y, startXYZ.z, startABC.x, startABC.y, startABC.z);
        endXYZ = getOptimizedHeads(endXYZ.x, endXYZ.y, endXYZ.z, endABC.x, endABC.y, endABC.z);
      } else { // guess at head adjustments
        var startDisplacement = machineConfiguration.getDirection(startABC);
        startDisplacement.multiply(headOffset);
        var endDisplacement = machineConfiguration.getDirection(endABC);
        endDisplacement.multiply(headOffset);
        startXYZ = Vector.sum(startTool, startDisplacement);
        endXYZ = Vector.sum(endTool, endDisplacement);
      }
    }
  } else { // calculate tool tip from XYZ, heads are always programmed in TCP mode, so not handled here
    startXYZ = getCurrentPosition();
    endXYZ = new Vector(_x, _y, _z);
    startTool = machineConfiguration.getOrientation(machineConfiguration.getTableABC(startABC)).multiply(startXYZ);
    endTool = machineConfiguration.getOrientation(machineConfiguration.getTableABC(endABC)).multiply(endXYZ);
  }

  // calculate axes movements
  moveLength.xyz = Vector.diff(endXYZ, startXYZ).abs;
  moveLength.xyzLength = moveLength.xyz.length;
  moveLength.abc = Vector.diff(endABC, startABC).abs;
  for (var i = 0; i < 3; ++i) {
    if (moveLength.abc.getCoordinate(i) > Math.PI) {
      moveLength.abc.setCoordinate(i, 2 * Math.PI - moveLength.abc.getCoordinate(i));
    }
  }
  moveLength.abcLength = moveLength.abc.length;

  // calculate radii
  moveLength.radius = getRotaryRadii(startTool, endTool, startABC, endABC);

  // calculate the radial portion of the tool tip movement
  var radialLength = Math.sqrt(
    Math.pow(getRadialDistance(moveLength.radius.x, startABC.x, endABC.x), 2.0) +
    Math.pow(getRadialDistance(moveLength.radius.y, startABC.y, endABC.y), 2.0) +
    Math.pow(getRadialDistance(moveLength.radius.z, startABC.z, endABC.z), 2.0)
  );

  // calculate the tool tip move length
  // tool tip distance is the move distance based on a combination of linear and rotary axes movement
  moveLength.tool = moveLength.xyzLength + radialLength;

  // debug
  if (false) {
    writeComment("DEBUG - tool   = " + moveLength.tool);
    writeComment("DEBUG - xyz    = " + moveLength.xyz);
    var temp = Vector.product(moveLength.abc, 180 / Math.PI);
    writeComment("DEBUG - abc    = " + temp);
    writeComment("DEBUG - radius = " + moveLength.radius);
  }
  return moveLength;
}
// End of multi-axis feedrate logic

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  var directionCode;
  if (isMirrored(getCircularPlane())) {
    directionCode = clockwise ? 3 : 2;
  } else {
    directionCode = clockwise ? 2 : 3;
  }

  if (machineState.useXZCMode) {
    switch (getCircularPlane()) {
    case PLANE_ZX:
      if (!isSpiral()) {
        var c = getCClosest(x, y, cOutput.getCurrent());
        if (!cFormat.areDifferent(c, cOutput.getCurrent())) {
          validate(getCircularSweep() < Math.PI, localize("Circular sweep exceeds limit."));
          var start = getCurrentPosition();
          writeBlock(gPlaneModal.format(18), gMotionModal.format(directionCode), xOutput.format(getModulus(x, y)), cOutput.format(c), zOutput.format(z), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
          previousABC.setZ(c);
          return;
        }
      }
      break;
    case PLANE_XY:
      var d2 = center.x * center.x + center.y * center.y;
      if (d2 < 1e-6) { // center is on rotary axis
        var c = getCWithinRange(x, y, cOutput.getCurrent(), !clockwise);
        if (!forceRewind) {
          writeBlock(gMotionModal.format(1), xOutput.format(getModulus(x, y)), cOutput.format(c), zOutput.format(z), getFeed(feed));
          previousABC.setZ(c);
          return;
        }
      }
      break;
    }

    linearize(getTolerance());
    return;
  }

  if (isSpeedFeedSynchronizationActive()) {
    error(localize("Speed-feed synchronization is not supported for circular moves."));
    return;
  }

  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for a circular move."));
    return;
  }

  var start = getCurrentPosition();
  forceXYZ();

  if (isFullCircle()) {
    if (getProperty("useRadius") || isHelical()) { // radius mode does not support full arcs
      linearize(tolerance);
      return;
    }
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(gPlaneModal.format(getG17Code()), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), (currentSection.spindle == SPINDLE_PRIMARY ? jOutput.format(cy - start.y, 0) : jOutput.format((cy - start.y) * -1, 0)), getFeed(feed));
      break;
    case PLANE_ZX:
      if (machineState.usePolarMode) {
        linearize(tolerance);
        return;
      }
      writeBlock(gPlaneModal.format(18), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), (currentSection.spindle == SPINDLE_PRIMARY ? iOutput.format(cx - start.x, 0) : iOutput.format((cx - start.x) * -1, 0)), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    case PLANE_YZ:
      if (machineState.usePolarMode) {
        linearize(tolerance);
        return;
      }
      writeBlock(gPlaneModal.format(19), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), jOutput.format(cy - start.y, 0), (currentSection.spindle == SPINDLE_PRIMARY ? kOutput.format(cz - start.z, 0) : kOutput.format((cz - start.z) * -1, 0)), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  } else if (!getProperty("useRadius")) {
    if (isHelical() && ((getCircularSweep() < toRad(30)) || (getHelicalPitch() > 10))) { // avoid G112 issue
      linearize(tolerance);
      return;
    }
    switch (getCircularPlane()) {
    case PLANE_XY:
      if (!xFormat.isSignificant(start.x) && machineState.usePolarMode) {
        writeBlock(gMotionModal.format(1), xOutput.format((unit == IN) ? 0.0001 : 0.001), getFeed(feed)); // move X to non zero to avoid G112 issues
      }

      writeBlock(gPlaneModal.format(getG17Code()), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), (currentSection.spindle == SPINDLE_PRIMARY ? jOutput.format(cy - start.y, 0) : jOutput.format((cy - start.y) * -1, 0)), getFeed(feed));
      break;
    case PLANE_ZX:
      if (machineState.usePolarMode) {
        linearize(tolerance);
        return;
      }
      writeBlock(gPlaneModal.format(18), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), (currentSection.spindle == SPINDLE_PRIMARY ? iOutput.format(cx - start.x, 0) : iOutput.format((cx - start.x) * -1, 0)), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    case PLANE_YZ:
      if (machineState.usePolarMode) {
        linearize(tolerance);
        return;
      }
      writeBlock(gPlaneModal.format(19), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), jOutput.format(cy - start.y, 0), (currentSection.spindle == SPINDLE_PRIMARY ? kOutput.format(cz - start.z, 0) : kOutput.format((cz - start.z) * -1, 0)), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  } else { // use radius mode
    if (isHelical() && ((getCircularSweep() < toRad(30)) || (getHelicalPitch() > 10))) {
      linearize(tolerance);
      return;
    }
    var r = getCircularRadius();
    if (toDeg(getCircularSweep()) > (180 + 1e-9)) {
      r = -r; // allow up to <360 deg arcs
    }
    switch (getCircularPlane()) {
    case PLANE_XY:
      if ((spatialFormat.format(start.x) == 0) && machineState.usePolarMode) {
        writeBlock(gMotionModal.format(1), xOutput.format((unit == IN) ? 0.0001 : 0.001), getFeed(feed)); // move X to non zero to avoid G112 issues
      }
      writeBlock(gPlaneModal.format(getG17Code()), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
      break;
    case PLANE_ZX:
      if (machineState.usePolarMode) {
        linearize(tolerance);
        return;
      }
      writeBlock(gPlaneModal.format(18), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
      break;
    case PLANE_YZ:
      if (machineState.usePolarMode) {
        linearize(tolerance);
        return;
      }
      writeBlock(gPlaneModal.format(19), gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  }
}

var subSupport;
function onCycle() {
  if ((typeof isSubSpindleCycle == "function") && isSubSpindleCycle(cycleType)) {

    // Start of stock transfer operation(s)

    if (machineState.spindlesAreAttached) {
      if (!retracted) {
        writeBlock(gRotationModal.format(69));
        writeRetract(X, Y);
        writeBlock(gFormat.format(0), gFormat.format(53), bOutput.format(0), ("Z#" + ((currentSection.spindle == SPINDLE_SECONDARY) ? zSubHomeParameter : zHomeParameter)));
        retracted = true;
        if (getProperty("optionalStop")) {
          onCommand(COMMAND_OPTIONAL_STOP);
          gMotionModal.reset();
        }
        writeln("");
      }
    } else {
      writeBlock(gRotationModal.format(69));
      onCommand(COMMAND_STOP_SPINDLE);
      onCommand(COMMAND_COOLANT_OFF);
      if (gotSecondarySpindle && previousPartSpindle == SPINDLE_SUB) {
        //writeBlock(gFormat.format(111), formatComment("Cross Axis Control cancel"));
      }

      if (!machineState.stockTransferIsActive) {
        if (cycleType != "secondary-spindle-return") {
          writeRetract(X, Y);
          writeRetract(Z);
          if (getProperty("optionalStop")) {
            onCommand(COMMAND_OPTIONAL_STOP);
            gMotionModal.reset();
          }
        }
      }
      writeln("");
      if (hasParameter("operation-comment")) {
        var comment = getParameter("operation-comment");
        if (comment) {
          writeComment(comment);
        }
      }
      gSelectSpindleModal.reset();
      writeBlock("T" + getProperty("transferTool"), mFormat.format(6));
      writeRetract(Z);
      gMotionModal.reset();
      gAbsIncModal.reset();

      var hasCutoff = false;

      if (!isLastSection()) {//Required if used on the last process
        var numberOfSections = getNumberOfSections();
        for (var i = getNextSection().getId(); i < numberOfSections; ++i) {
          var section = getSection(i);
          //Cutoff process;
          if ((section.hasParameter("operation-strategy") && section.getParameter("operation-strategy") == "turningPart")) {
            hasCutoff = true;
          }
        }
      }
      if (hasCutoff) {
        writeBlock(gMotionModal.format(0), gAbsIncModal.format(90), zOutput.format(0), bOutput.format(toRad(90)), formatComment("CLEAR"));
        retracted = true;
      }
      var feedMode = getCode("FEED_MODE_UNIT_MIN", getSpindle(TOOL));
      if (cycle.stopSpindle) {
        cAxisEngageModal.reset();
        forceABC();
        gMotionModal.reset();
        writeBlock(feedMode, gPlaneModal.format(18));
        writeBlock(mFormat.format(901));
        writeBlock(getCode("ENABLE_C_AXIS"), formatComment("C1 AXIS ON"));
        writeBlock(gMotionModal.format(0), cOutput.format(0), formatComment("MAIN ANGLE"));
        writeBlock(mFormat.format(902));
        writeBlock(mFormat.format(300), formatComment("C2 AXIS ON"));
        gMotionModal.reset();
        forceABC();
        writeBlock(gMotionModal.format(0), uOutput.format(cycle.spindleOrientation), formatComment("SUB ANGLE"));
        writeBlock(mFormat.format(901));
        gMotionModal.reset();
        cOutput.reset();
      }
      gFeedModeModal.reset();
      gPlaneModal.reset();
      if (!getProperty("optimizeCAxisSelect")) {
        cAxisEngageModal.reset();
      }
    }

    switch (cycleType) {
    case "secondary-spindle-return":
      var secondaryPull = false;
      var secondaryHome = false;
      // pull part only (when offset!=0), Return secondary spindle to home (when offset=0)
      var feedDis = 0;
      var feedPosition = cycle.feedPosition;
      if (cycle.useMachineFrame == 1) {
        if (hasParameter("operation:feedPlaneHeight_direct")) { // Inventor
          feedDis = getParameter("operation:feedPlaneHeight_direct");
        } else if (hasParameter("operation:feedPlaneHeightDirect")) { // HSMWorks
          feedDis = getParameter("operation:feedPlaneHeightDirect");
        }
        feedPosition = feedDis;
      } else if (hasParameter("operation:feedPlaneHeight_offset")) { // Inventor
        feedDis = getParameter("operation:feedPlaneHeight_offset");
      } else if (hasParameter("operation:feedPlaneHeightOffset")) { // HSMWorks
        feedDis = getParameter("operation:feedPlaneHeightOffset");
      }

      // Transfer part to secondary spindle
      if (cycle.unclampMode != "keep-clamped") {
        secondaryPull = feedDis != 0;
        secondaryHome = true;
      } else {
        // pull part only (when offset!=0), Return secondary spindle to home (when offset=0)
        secondaryPull = feedDis != 0;
        secondaryHome = !secondaryPull;
      }

      if (secondaryPull) {
        writeBlock(getCode("UNCLAMP_CHUCK"), formatComment("UNCLAMP MAIN CHUCK"));
        onDwell(cycle.dwell);
        writeBlock(conditional(cycle.useMachineFrame, gFormat.format(53)), gMotionModal.format(1), subWOutput.format(subSupport) + "+" + spatialFormat.format(cycle.feedPosition) + "]", getFeed(cycle.feedrate), formatComment("BAR PULL"));
      }
      if (secondaryHome) {
        if (cycle.unclampMode == "unclamp-secondary") { // simple bar pulling operation
          writeBlock(getCode("UNCLAMP_SECONDARY_CHUCK"), formatComment("UNCLAMP SUB CHUCK"));
          onDwell(1);
        } else if (cycle.unclampMode == "unclamp-primary") {
          writeBlock(getCode("UNCLAMP_CHUCK"), formatComment("UNCLAMP MAIN CHUCK"));
          onDwell(1);
        }
        writeBlock(mFormat.format(541), formatComment("Transfer Mode Cancel"));
        gMotionModal.reset();
        writeBlock(gMotionModal.format(0), gFormat.format(53), barOutput.format(0), formatComment("SUB SPINDLE RETURN"));
        if (!cycle.stopSpindle) {
          writeBlock(getCode("SPINDLE_SYNCHRONIZATION_SPEED_OFF", getSpindle(PART)), formatComment("SYNCRHONIZATION OFF"));
          writeBlock(getCode("STOP_SUB_SPINDLE"), formatComment("SUB SPINDLE STOP"));
        }
        machineState.spindlesAreAttached = false;
      } else {
        writeBlock(getCode("CLAMP_CHUCK"), formatComment("CLAMP MAIN CHUCK"));
        onDwell(cycle.dwell);
        machineState.spindlesAreAttached = true;
      }
      machineState.stockTransferIsActive = true;
      break;
    case "secondary-spindle-grab":
      if (currentSection.partCatcher) {
        engagePartCatcher(true);
      }
      /*writeBlock(mFormat.format(getCode("INTERLOCK_BYPASS", getSecondarySpindle())), formatComment("INTERLOCK BYPASS"));*/

      writeBlock(getCode("UNCLAMP_SECONDARY_CHUCK"), formatComment("UNCLAMP SUB CHUCK"));

      onDwell(cycle.dwell);
      gSpindleModeModal.reset();
      if (currentSection.partCatcher) {
        writeBlock(mFormat.format(getCode("PART_CATCHER_OFF", true)), formatComment(localize("PART CATCHER OFF")));
      }
      if (airCleanChuck) {
      // clean out chips
        writeBlock(mFormat.format(getCode("AIR_BLAST_ON", getSpindle(PART))), formatComment("MAIN SPINDLE AIR BLOW ON"));
        onDwell(1);
        writeBlock(mFormat.format(getCode("AIR_BLAST_OFF", getSpindle(PART))), formatComment("MAIN SPINDLE AIR BLOW OFF"));
        onDwell(1);
        writeBlock(mFormat.format(getCode("AIR_BLAST_ON", getSecondarySpindle())), formatComment("SUB SPINDLE AIR BLOW ON"));
        onDwell(1);
        writeBlock(mFormat.format(getCode("AIR_BLAST_OFF", getSecondarySpindle())), formatComment("SUB SPINDLE AIR BLOW OFF"));
        onDwell(1);
      }
      if (cycle.stopSpindle) { // no spindle rotation
        /*writeBlock(
          mFormat.format(getCode("ORIENT_SPINDLE", getSpindle(PART))),
          mFormat.format(getCode("ORIENT_SPINDLE", getSecondarySpindle())),
          formatComment("SPINDLE ORIENTATION")
        );*/
        lastSpindleSpeed = 0;
      } else { // phase syncronization
        writeBlock(getCode("STOP_MAIN_SPINDLE"), formatComment("MAIN SPINDLE STOP"));
        writeBlock(getCode("STOP_SUB_SPINDLE"), formatComment("SUB SPINDLE STOP"));
        writeBlock(mFormat.format(901));
        writeBlock(getCode("DISABLE_C_AXIS", getSpindle(PART)));
        gSpindleModeModal.reset();
        writeBlock(getCode("CONSTANT_SURFACE_SPEED_OFF"), sOutput.format(cycle.spindleSpeed), getCode("START_MAIN_SPINDLE_CW"));

        lastSpindleMode = SPINDLE_CONSTANT_SPINDLE_SPEED;
        lastSpindleSpeed = cycle.spindleSpeed;
        lastSpindleDirection = true;
      }
      writeBlock(getCode("SPINDLE_SYNCHRONIZATION_PHASE"), formatComment("PHASE SYNCHRONIZATION"));
      writeBlock(mFormat.format(540), formatComment("Transfer Mode on"));
      // approach part
      gMotionModal.reset();
      writeBlock(conditional(cycle.useMachineFrame, gFormat.format(53)), gMotionModal.format(0), subWOutput.format(cycle.feedPosition) + "]", formatComment("MOVE HD2 TO APPROACH"));
      //For possible pull operation
      subSupport = cycle.chuckPosition;

      if (transferUseTorque) { //G31 Mode
        writeBlock("#3030=70", formatComment("THRUST FACTOR"));
        writeBlock(getCode("TORQUE_SKIP_ON", getSpindle(PART)), formatComment("PUSH PRESS ON"));
        writeBlock(conditional(cycle.useMachineFrame, gFormat.format(53)), gMotionModal.format(31), subWOutput.format(cycle.chuckPosition) + "]", getFeed(cycle.feedrate), formatComment("G31 PUSH"));
        writeBlock(getCode("TORQUE_SKIP_OFF", getSpindle(PART)), formatComment("PUSH PRESS OFF"));
      } else {
        writeBlock(conditional(cycle.useMachineFrame, gFormat.format(53)), gMotionModal.format(1), subWOutput.format(cycle.chuckPosition) + "]", getFeed(cycle.feedrate));
      }
      writeBlock(mFormat.format(541), formatComment("Transfer Mode Cancel"));
      gMotionModal.reset();
      writeBlock(getCode("CLAMP_SECONDARY_CHUCK"), formatComment("CLAMP SUB CHUCK"));
      //writeBlock(getCode("SPINDLE_SYNCHRONIZATION_SPEED"), formatComment("SPEED SYNCHRONIZATION"));
      onDwell(1);
      machineState.stockTransferIsActive = true;
      machineState.spindlesAreAttached = true;
      break;
    }
  }

  if (cycleType == "stock-transfer") {
    warning(localize("Stock transfer is not supported. Required machine specific customization."));
    return;
  }
}

var saveShowSequenceNumbers;
var pathBlockNumber = {start:0, end:0};

function onCyclePath() {
  saveShowSequenceNumbers = showSequenceNumbers;

  // buffer all paths and stop feeds being output
  feedOutput.disable();
  showSequenceNumbers = "false";
  redirectToBuffer();
  gMotionModal.reset();
  xOutput.reset();
  zOutput.reset();
}

function onCyclePathEnd() {
  showSequenceNumbers = saveShowSequenceNumbers; // reset property to initial state
  feedOutput.enable();
  var cyclePath = String(getRedirectionBuffer()).split(EOL); // get cycle path from buffer
  closeRedirection();
  for (line in cyclePath) { // remove empty elements
    if (cyclePath[line] == "") {
      cyclePath.splice(line);
    }
  }

  var verticalPasses;
  if (cycle.profileRoughingCycle == 0) {
    verticalPasses = false;
  } else if (cycle.profileRoughingCycle == 1) {
    verticalPasses = true;
  } else {
    error(localize("Unsupported passes type."));
    return;
  }
  // output cycle data
  switch (cycleType) {
  case "turning-canned-rough":
    writeBlock(gFormat.format(verticalPasses ? 272 : 271),
      (verticalPasses ? "W" : "U") + spatialFormat.format(cycle.depthOfCut),
      "R" + spatialFormat.format(cycle.retractLength)
    );
    writeBlock(gFormat.format(verticalPasses ? 272 : 271),
      "P" + (getStartEndSequenceNumber(cyclePath, true)),
      "Q" + (getStartEndSequenceNumber(cyclePath, false)),
      "U" + xFormat.format(cycle.xStockToLeave),
      "W" + spatialFormat.format(cycle.zStockToLeave),
      getFeed(cycle.cutfeedrate)
    );
    break;
  default:
    error(localize("Unsupported turning canned cycle."));
  }

  for (var i = 0; i < cyclePath.length; ++i) {
    if (i == 0 || i == (cyclePath.length - 1)) { // write sequence number on first and last line of the cycle path
      showSequenceNumbers = "true";
      if ((i == 0 && pathBlockNumber.start != sequenceNumber) || (i == (cyclePath.length - 1) && pathBlockNumber.end != sequenceNumber)) {
        error(localize("Mismatch of start/end block number in turning canned cycle."));
        return;
      }
    }
    writeBlock(cyclePath[i]); // output cycle path
    showSequenceNumbers = saveShowSequenceNumbers; // reset property to initial state
  }
}

function getStartEndSequenceNumber(cyclePath, start) {
  if (start) {
    pathBlockNumber.start = sequenceNumber + conditional(saveShowSequenceNumbers == "true", getProperty("sequenceNumberIncrement"));
    return pathBlockNumber.start;
  } else {
    pathBlockNumber.end = sequenceNumber + getProperty("sequenceNumberIncrement") + conditional(saveShowSequenceNumbers == "true", (cyclePath.length - 1) * getProperty("sequenceNumberIncrement"));
    return pathBlockNumber.end;
  }
}

function getCommonCycle(x, y, z, r) {
  forceXYZ(); // force xyz on first drill hole of any cycle
  if (machineState.useXZCMode) {
    var c = getCWithinRange(x, y, cOutput.getCurrent());
    cOutput.reset();
    return [xOutput.format(getModulus(x, y)), cOutput.format(c),
      zOutput.format(z),
      "R" + spatialFormat.format(r)];
  } else {
    return [xOutput.format(x), yOutput.format(y),
      zOutput.format(z),
      "R" + spatialFormat.format(r)];
  }
}

var threadStart;
var threadEnd;
function moveToThreadStart(x, y, z) {
  var cuttingAngle = 0;
  if (hasParameter("operation:infeedAngle")) {
    cuttingAngle = getParameter("operation:infeedAngle");
  }
  if (cuttingAngle != 0) {
    var zz;
    if (isFirstCyclePoint()) {
      threadStart = getCurrentPosition();
      threadEnd = new Vector(x, y, z);
    } else {
      var zz = threadStart.z - (Math.abs(threadEnd.x - x) * Math.tan(toRad(cuttingAngle)));
      writeBlock(gMotionModal.format(0), zOutput.format(zz));
      xOutput.reset();
      zOutput.reset();
      g92ROutput.reset();
      feedOutput.reset();
      threadStart.setZ(zz);
      threadEnd = new Vector(x, y, z);
    }
  }
}

function onCyclePoint(x, y, z) {
  if (!getProperty("useCycles")) {
    expandCyclePoint(x, y, z);
    return;
  }
  writeBlock(gPlaneModal.format(getG17Code()));

  switch (cycleType) {
  case "thread-turning":
    if (getProperty("useSimpleThread") ||
      (hasParameter("operation:doMultipleThreads") && (getParameter("operation:doMultipleThreads") != 0)) ||
      (hasParameter("operation:infeedMode") && (getParameter("operation:infeedMode") != "constant"))) {
      var r = -cycle.incrementalX; // positive if taper goes down - delta radius
      moveToThreadStart(x, y, z);
      var threadsPerInch = 1.0 / cycle.pitch; // per mm for metric
      var f = 1 / threadsPerInch;
      writeBlock(
        gMotionModal.format(292),
        xOutput.format(x - cycle.incrementalX),
        yOutput.format(y),
        zOutput.format(z),
        conditional(zFormat.isSignificant(r), g92ROutput.format(r)),
        feedOutput.format(f)
      );
    } else {
      if (isLastCyclePoint()) {
        // thread height and depth of cut
        var threadHeight = getParameter("operation:threadDepth");
        var firstDepthOfCut = threadHeight / getParameter("operation:numberOfStepdowns");

        // first G76 block
        var repeatPass = hasParameter("operation:nullPass") ? getParameter("operation:nullPass") : 0;
        var chamferWidth = 10; // Pullout-width is 1*thread-lead in 1/10's;
        var materialAllowance = 0; // Material allowance for finishing pass
        var cuttingAngle = getParameter("operation:infeedAngle", 30) * 2; // Angle is not stored with tool. toDeg(tool.getTaperAngle());
        var pcode = repeatPass * 10000 + chamferWidth * 100 + cuttingAngle;
        gCycleModal.reset();
        writeBlock(
          gCycleModal.format(276),
          threadP1Output.format(pcode),
          threadQOutput.format(firstDepthOfCut),
          threadROutput.format(materialAllowance)
        );

        // second G76 block
        var r = -cycle.incrementalX; // positive if taper goes down - delta radius
        gCycleModal.reset();
        writeBlock(
          gCycleModal.format(276),
          xOutput.format(x),
          zOutput.format(z),
          conditional(zFormat.isSignificant(r), threadROutput.format(r)),
          threadP2Output.format(threadHeight),
          threadQOutput.format(firstDepthOfCut),
          pitchOutput.format(cycle.pitch)
        );
        forceFeed();
      }
    }
    return;
  }

  if (isFirstCyclePoint() || (getParameter("operation:cycleType") == "tapping-with-chip-breaking")) {
    repositionToCycleClearance(cycle, x, y, z);

    // return to initial Z which is clearance plane and set absolute mode

    var F = (machineState.feedPerRevolution ? cycle.feedrate / spindleSpeed : cycle.feedrate);
    var P = !cycle.dwell ? 0 : clamp(1, cycle.dwell * 1000, 99999999); // in milliseconds

    switch (cycleType) {
    case "drilling":
      writeBlock(
        gRetractModal.format(98), gAbsIncModal.format(90), gCycleModal.format(81),
        getCommonCycle(x, y, z, cycle.retract),
        feedOutput.format(F)
      );
      break;
    case "counter-boring":
      writeBlock(
        gRetractModal.format(98), gAbsIncModal.format(90), gCycleModal.format(83),
        getCommonCycle(x, y, z, cycle.retract),
        "Q" + spatialFormat.format(cycle.incrementalDepth),
        conditional(P > 0, "P" + milliFormat.format(P)),
        feedOutput.format(F)
      );
      break;
    case "deep-drilling":
      writeBlock(
        gRetractModal.format(98), gAbsIncModal.format(90), gCycleModal.format(83),
        getCommonCycle(x, y, z, cycle.retract),
        "Q" + spatialFormat.format(cycle.incrementalDepth),
        conditional(P > 0, "P" + milliFormat.format(P)),
        feedOutput.format(F)
      );
      break;
    case "chip-breaking":
      if (cycle.accumulatedDepth < cycle.depth) {
        expandCyclePoint(x, y, z);
      } else {
        writeBlock(
          gRetractModal.format(98), gAbsIncModal.format(90), gCycleModal.format(73),
          getCommonCycle(x, y, z, cycle.retract),
          "Q" + spatialFormat.format(cycle.incrementalDepth),
          "D" + spatialFormat.format(cycle.chipBreakDistance),
          conditional(P > 0, "P" + milliFormat.format(P)),
          feedOutput.format(F)
        );
      }
      break;
    case "tapping":
      if (!F) {
        F = tool.getTappingFeedrate();
      }
      if (getProperty("useRigidTapping")) {
        writeBlock(
          gRetractModal.format(98),
          gCycleModal.format((tool.type == TOOL_TAP_LEFT_HAND) ? 84.3 : 84.2),
          getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
          feedOutput.format(F)
        );
      } else {
        writeBlock(
          gRetractModal.format(98),
          gCycleModal.format((tool.type == TOOL_TAP_LEFT_HAND) ? 74 : 84),
          getCommonCycle(x, y, z, cycle.retract, cycle.clearance),
          feedOutput.format(F)
        );
      }
      forceFeed();
      break;
    case "right-tapping":
      if (!F) {
        F = tool.getTappingFeedrate();
      }
      if (getProperty("useRigidTapping")) {
        writeBlock(
          gRetractModal.format(98),
          gCycleModal.format(84.2),
          getCommonCycle(x, y, z, cycle.retract),
          pitchOutput.format(F)
        );
      } else {
        writeBlock(
          gRetractModal.format(98),
          gCycleModal.format(84),
          getCommonCycle(x, y, z, cycle.retract),
          pitchOutput.format(F)
        );
      }
      forceFeed();
      break;
    case "left-tapping":
      if (!F) {
        F = tool.getTappingFeedrate();
      }
      if (getProperty("useRigidTapping")) {
        writeBlock(
          gRetractModal.format(98),
          gCycleModal.format(84.3),
          getCommonCycle(x, y, z, cycle.retract),
          pitchOutput.format(F)
        );
      } else {
        writeBlock(
          gRetractModal.format(98),
          gCycleModal.format(74),
          getCommonCycle(x, y, z, cycle.retract),
          pitchOutput.format(F)
        );
      }
      forceFeed();
      break;
    case "tapping-with-chip-breaking":
      // if (cycle.accumulatedDepth < cycle.depth) {
      //  error(localize("Accumulated pecking depth is not supported for canned tapping cycles with chip breaking."));
      //  return;
      //}
      if (!F) {
        F = tool.getTappingFeedrate();
      }

      var u = cycle.stock;
      var step = cycle.incrementalDepth;
      var first = true;

      while (u > cycle.bottom) {
        if (step < cycle.minimumIncrementalDepth) {
          step = cycle.minimumIncrementalDepth;
        }
        u -= step;
        step -= cycle.incrementalDepthReduction;
        gCycleModal.reset(); // required
        u = Math.max(u, cycle.bottom);
        //Sub Spindle needs reversed here
        var depth = u * (getSpindle(PART) == SPINDLE_MAIN ? 1 : -1);

        if (first) {
          first = false;
          writeBlock(
            gRetractModal.format(99), gAbsIncModal.format(90), gCycleModal.format((tool.type == TOOL_TAP_LEFT_HAND) ? 84.3 : 84.2),
            getCommonCycle(x, y, depth, cycle.retract),
            pitchOutput.format(tool.threadPitch)
          );
        } else {
          xOutput.reset();
          writeBlock(
            conditional(u <= cycle.bottom, gRetractModal.format(98)),
            gAbsIncModal.format(90),
            xOutput.format(machineState.useXZCMode ? getModulus(x, y) : x),
            "Z" + zFormat.format(depth)
          );
        }
      }
      forceFeed();
      break;
    case "reaming":
      if (feedFormat.getResultingValue(cycle.feedrate) != feedFormat.getResultingValue(cycle.retractFeedrate)) {
        expandCyclePoint(x, y, z);
        break;
      }
      writeBlock(
        gRetractModal.format(98), gAbsIncModal.format(90), gCycleModal.format(85),
        getCommonCycle(x, y, z, cycle.retract),
        conditional(P > 0, "P" + milliFormat.format(P)),
        feedOutput.format(F)
      );
      break;
    default:
      expandCyclePoint(x, y, z);
    }
  } else {
    if (cycleExpanded) {
      expandCyclePoint(x, y, z);
    } else if (machineState.useXZCMode) {
      var _x = xOutput.format(getModulus(x, y));
      var _c = cOutput.format(getCWithinRange(x, y, cOutput.getCurrent()));
      if (!_x /*&& !_y*/ && !_c) {
        xOutput.reset(); // at least one axis is required
        _x = xOutput.format(getModulus(x, y));
      }
      writeBlock(_x, _c);
    } else {
      var _x = xOutput.format(x);
      var _y = yOutput.format(y);
      var _z = zOutput.format(z);
      if (!_x && !_y && !_z) {
        switch (gPlaneModal.getCurrent()) {
        case 17: // XY
          xOutput.reset(); // at least one axis is required
          _x = xOutput.format(x);
          break;
        case 18: // ZX
          zOutput.reset(); // at least one axis is required
          _z = zOutput.format(z);
          break;
        case 19: // YZ
          yOutput.reset(); // at least one axis is required
          _y = yOutput.format(y);
          break;
        }
      }
      writeBlock(_x, _y, _z);
    }
  }
}

function onCycleEnd() {
  if (!cycleExpanded && !machineState.stockTransferIsActive) {
    switch (cycleType) {
    case "thread-turning":
      forceFeed();
      xOutput.reset();
      zOutput.reset();
      g92ROutput.reset();
      break;
    default:
      writeBlock(gCycleModal.format(80));
    }
  }
}

function onPassThrough(text) {
  writeBlock(text);
}

function onParameter(name, value) {
  var invalid = false;
  switch (name) {
  case "action":
    if (String(value).toUpperCase() == "USEXZCMODE") {
      forceXZCMode = false;
      forcePolarMode = false;
    } else if (String(value).toUpperCase() == "USEPOLARMODE") {
      forcePolarMode = false;
      forceXZCMode = false;
    } else if (String(value).toUpperCase() == "USESMOOTHING") {
      useSmoothing = true;
    } else {
      invalid = true;
    }
  }
  if (invalid) {
    error(localize("Invalid action parameter: ") + value);
    return;
  }
}

var currentCoolantMode = COOLANT_OFF;
var currentCoolantTurret = 1;
var coolantOff = undefined;
var isOptionalCoolant = false;
var forceCoolant = false;

function setCoolant(coolant, turret) {
  var coolantCodes = getCoolantCodes(coolant, turret);
  if (Array.isArray(coolantCodes)) {
    if (singleLineCoolant) {
      skipBlock = isOptionalCoolant;
      writeBlock(coolantCodes.join(getWordSeparator()));
    } else {
      for (var c in coolantCodes) {
        skipBlock = isOptionalCoolant;
        writeBlock(coolantCodes[c]);
      }
    }
    return undefined;
  }
  return coolantCodes;
}

function getCoolantCodes(coolant, turret) {
  turret = gotMultiTurret ? (turret == undefined ? 1 : turret) : 1;
  isOptionalCoolant = false;
  var multipleCoolantBlocks = new Array(); // create a formatted array to be passed into the outputted line
  if (!coolants) {
    error(localize("Coolants have not been defined."));
  }
  if (tool.type == TOOL_PROBE) { // avoid coolant output for probing
    coolant = COOLANT_OFF;
  }
  if (coolant == currentCoolantMode && turret == currentCoolantTurret) {
    if ((typeof operationNeedsSafeStart != "undefined" && operationNeedsSafeStart) && coolant != COOLANT_OFF) {
      isOptionalCoolant = true;
    } else if (!forceCoolant || coolant == COOLANT_OFF) {
      return undefined; // coolant is already active
    }
  }
  if ((coolant != COOLANT_OFF) && (currentCoolantMode != COOLANT_OFF) && (coolantOff != undefined) && !forceCoolant && !isOptionalCoolant) {
    if (Array.isArray(coolantOff)) {
      for (var i in coolantOff) {
        multipleCoolantBlocks.push(coolantOff[i]);
      }
    } else {
      multipleCoolantBlocks.push(coolantOff);
    }
  }
  forceCoolant = false;

  var m;
  var coolantCodes = {};
  for (var c in coolants) { // find required coolant codes into the coolants array
    if (coolants[c].id == coolant) {
      var localCoolant = parseCoolant(coolants[c], turret);
      localCoolant = typeof localCoolant == "undefined" ? coolants[c] : localCoolant;
      coolantCodes.on = localCoolant.on;
      if (localCoolant.off != undefined) {
        coolantCodes.off = localCoolant.off;
        break;
      } else {
        for (var i in coolants) {
          if (coolants[i].id == COOLANT_OFF) {
            coolantCodes.off = localCoolant.off;
            break;
          }
        }
      }
    }
  }
  if (coolant == COOLANT_OFF) {
    m = !coolantOff ? coolantCodes.off : coolantOff; // use the default coolant off command when an 'off' value is not specified
  } else {
    coolantOff = coolantCodes.off;
    m = coolantCodes.on;
  }

  if (!m) {
    onUnsupportedCoolant(coolant);
    m = 9;
  } else {
    if (Array.isArray(m)) {
      for (var i in m) {
        multipleCoolantBlocks.push(m[i]);
      }
    } else {
      multipleCoolantBlocks.push(m);
    }
    currentCoolantMode = coolant;
    currentCoolantTurret = turret;
    for (var i in multipleCoolantBlocks) {
      if (typeof multipleCoolantBlocks[i] == "number") {
        multipleCoolantBlocks[i] = mFormat.format(multipleCoolantBlocks[i]);
      }
    }
    return multipleCoolantBlocks; // return the single formatted coolant value
  }
  return undefined;
}

function parseCoolant(coolant, turret) {
  var localCoolant;
  if (getSpindle(true) == SPINDLE_MAIN) {
    localCoolant = turret == 1 ? coolant.spindle1t1 : coolant.spindle1t2;
    localCoolant = typeof localCoolant == "undefined" ? coolant.spindle1 : localCoolant;
  } else if (getSpindle(true) == SPINDLE_LIVE) {
    localCoolant = turret == 1 ? coolant.spindleLivet1 : coolant.spindleLivet2;
    localCoolant = typeof localCoolant == "undefined" ? coolant.spindleLive : localCoolant;
  } else {
    localCoolant = turret == 1 ? coolant.spindle2t1 : coolant.spindle2t2;
    localCoolant = typeof localCoolant == "undefined" ? coolant.spindle2 : localCoolant;
  }
  localCoolant = typeof localCoolant == "undefined" ? (turret == 1 ? coolant.turret1 : coolant.turret2) : localCoolant;
  localCoolant = typeof localCoolant == "undefined" ? coolant : localCoolant;
  return localCoolant;
}

function onCommand(command) {
  switch (command) {
  case COMMAND_COOLANT_OFF:
    setCoolant(COOLANT_OFF, machineState.currentTurret);
    break;
  case COMMAND_LOCK_MULTI_AXIS:
    writeBlock(currentSection.spindle == SPINDLE_PRIMARY ? getCode("CLAMP_PRIMARY_SPINDLE") : getCode("CLAMP_SECONDARY_SPINDLE")); // C-axis
    // if (gotBAxis) {
    //   writeBlock(getCode("CLAMP_B_AXIS")); // B-axis
    // }
    break;
  case COMMAND_UNLOCK_MULTI_AXIS:
    if (gotBAxis) {
      writeBlock(getCode("UNCLAMP_B_AXIS")); // B-axis
    }
    writeBlock(currentSection.spindle == SPINDLE_PRIMARY ? getCode("UNCLAMP_PRIMARY_SPINDLE") : getCode("UNCLAMP_SECONDARY_SPINDLE")); // C-axis
    break;
  case COMMAND_START_CHIP_TRANSPORT:
    // writeBlock(getCode("START_CHIP_TRANSPORT"));
    break;
  case COMMAND_STOP_CHIP_TRANSPORT:
    // writeBlock(getCode("STOP_CHIP_TRANSPORT"));
    break;
  case COMMAND_BREAK_CONTROL:
    break;
  case COMMAND_ACTIVATE_SPEED_FEED_SYNCHRONIZATION:
    break;
  case COMMAND_DEACTIVATE_SPEED_FEED_SYNCHRONIZATION:
    break;
  case COMMAND_STOP:
    writeBlock(mFormat.format(0));
    forceSpindleSpeed = true;
    forceCoolant = true;
    break;
  case COMMAND_OPTIONAL_STOP:
    writeBlock(mFormat.format(1));
    forceSpindleSpeed = true;
    forceCoolant = true;
    break;
  case COMMAND_END:
    writeBlock(mFormat.format(2));
    break;
  case COMMAND_SPINDLE_CLOCKWISE:
    if (currentSection.spindle == SPINDLE_PRIMARY) {
      if (machineState.isTurningOperation || machineState.axialCenterDrilling) {
        writeBlock(getCode("START_MAIN_SPINDLE_CW"));
      } else {
        writeBlock(getCode("START_LIVE_TOOL_CW"));
      }
    } else {
      if (machineState.isTurningOperation || machineState.axialCenterDrilling) {
        writeBlock(getCode("START_SUB_SPINDLE_CW"));
      } else {
        writeBlock(getCode("START_LIVE_TOOL_CW"));
      }
    }
    break;
  case COMMAND_SPINDLE_COUNTERCLOCKWISE:
    if (currentSection.spindle == SPINDLE_PRIMARY) {
      if (machineState.isTurningOperation || machineState.axialCenterDrilling) {
        writeBlock(getCode("START_MAIN_SPINDLE_CCW"));
      } else {
        writeBlock(getCode("START_LIVE_TOOL_CCW"));
      }
    } else { // secondary
      if (machineState.isTurningOperation || machineState.axialCenterDrilling) {
        writeBlock(getCode("START_SUB_SPINDLE_CCW"));
      } else {
        writeBlock(getCode("START_LIVE_TOOL_CCW"));
      }
    }
    break;
  case COMMAND_STOP_SPINDLE:
    if (currentSection.spindle == SPINDLE_PRIMARY) {
      if (machineState.isTurningOperation || machineState.axialCenterDrilling) {
        writeBlock(getCode("STOP_MAIN_SPINDLE"));
      } else {
        writeBlock(getCode("STOP_LIVE_TOOL"));
      }
    } else {
      if (machineState.isTurningOperation || machineState.axialCenterDrilling) {
        writeBlock(getCode("STOP_SUB_SPINDLE"));
      } else {
        writeBlock(getCode("STOP_LIVE_TOOL"));
      }
    }
    lastSpindleSpeed = 0;
    lastSpindleDirection = undefined;
    sOutput.reset();
    break;
  default:
    onUnsupportedCommand(command);
  }
}

function getG17Code() {
  return machineState.usePolarMode ? 17 : 17;
}

function engagePartCatcher(engage) {
  if (engage) {
    if (machineState.spindlesAreAttached) {
      error(localize("Cannot eject part when spindles are connected."));
    }
    // catch part here
    writeBlock(getCode("PART_CATCHER_ON"), formatComment(localize("PART CATCHER ON")));
  } else {
    onCommand(COMMAND_COOLANT_OFF);
    //writeRetract(X, Y);
    //writeRetract(Z);
    //writeRetract(Y);
    writeBlock(getCode("PART_CATCHER_OFF"), formatComment(localize("PART CATCHER OFF")));
    forceXYZ();
  }
}

function onSectionEnd() {

  if (useSmoothing) {
    setSmoothing(false);
    useSmoothing = false;
  }

  if (machineState.usePolarMode) {
    setPolarMode(false); // disable polar interpolation mode
  }

  if (getProperty("useG61")) {
    setGeometryComp(false);
  }
  // cancel SFM mode to preserve spindle speed
  if ((tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) && !machineState.spindlesAreAttached) {
    startSpindle(true, getFramePosition(currentSection.getFinalPosition()));
  }

  if (getProperty("usePartCatcher") && partCutoff && currentSection.partCatcher) {
    engagePartCatcher(false);
  }

  if (partCutoff) {
    machineState.spindlesAreAttached = false;
  }

  if (((getCurrentSectionId() + 1) >= getNumberOfSections()) ||
      (tool.number != getNextSection().getTool().number)) {
    onCommand(COMMAND_BREAK_CONTROL);
  }

  if (hasNextSection()) {
    if (getNextSection().getTool().coolant != currentSection.getTool().coolant) {
      setCoolant(COOLANT_OFF, machineState.currentTurret);
    }
  }

  if (currentSection.isMultiAxis() && useTCPC) {
    writeBlock(gFormat.format(49));
  }

  if (getSpindle(PART) == SPINDLE_SUB) {
    invertAxes(false, false);
  }

  forceXYZ();
  forceXZCMode = false;
  forcePolarMode = false;
  partCutoff = false;
}

/** Output block to do safe retract and/or move to home position. */
function writeRetract() {
  var words = []; // store all retracted axes in an array
  for (var i = 0; i < arguments.length; ++i) {
    let instances = 0; // checks for duplicate retract calls
    for (var j = 0; j < arguments.length; ++j) {
      if (arguments[i] == arguments[j]) {
        ++instances;
      }
    }
    if (instances > 1) { // error if there are multiple retract calls for the same axis
      error(localize("Cannot retract the same axis twice in one line"));
      return;
    }
    switch (arguments[i]) {
    case X:
      xOutput.reset();
      //words.push("X#" + xHomeParameter);
      words.push("X" + xFormat.format(0));
      retracted = true; // specifies that the tool has been retracted to the safe plane
      break;
    case Y:
      if (gotYAxis) {
        yOutput.reset();
        //words.push("Y#" + yHomeParameter);
        words.push("Y" + yFormat.format(0));
      }
      break;
    case Z:
      zOutput.reset();
      words.push("Z#" + ((currentSection.spindle == SPINDLE_SECONDARY) ? zSubHomeParameter : zHomeParameter));
      retracted = true; // specifies that the tool has been retracted to the safe plane
      break;
    default:
      error(localize("Bad axis specified for writeRetract()."));
      return;
    }
  }
  gMotionModal.reset();
  if (words.length > 0) {
    writeBlock(gAbsIncModal.format(90), gMotionModal.format(0), gFormat.format(53), words); // retract
  }
  forceXYZ();
}

function onClose() {
  writeln("");

  optionalSection = false;
  writeBlock(gRotationModal.format(69));
  if (machineState.liveToolIsActive) {
    writeBlock(getCode("STOP_LIVE_TOOL"));
  } else if (machineState.mainSpindleIsActive) {
    writeBlock(getCode("STOP_MAIN_SPINDLE"));
  } else if (machineState.subSpindleIsActive) {
    writeBlock(getCode("STOP_SUB_SPINDLE"));
  }

  onCommand(COMMAND_COOLANT_OFF);

  if (!machineState.spindlesAreAttached) {
    writeRetract(X, Y);
    writeRetract(Z);
  } else {
    writeRetract(X, Y);
    forceABC();
    writeBlock(gFormat.format(0), gFormat.format(53), bOutput.format(0), ("Z#" + ((currentSection.spindle == SPINDLE_SECONDARY) ? zSubHomeParameter : zHomeParameter)));
  }

  if (machineState.tailstockIsActive) {
    writeBlock(getCode("TAILSTOCK_OFF"));
    writeBlock(mFormat.format(232), formatComment("RETURN TAILSTOCK TO HOME POSITION"));
  }

  if (gotSecondarySpindle) {
    //Not needed when using U for C2
    //writeBlock(gSpindleModal.format(111));
  }
  writeln("");
  onImpliedCommand(COMMAND_END);
  onImpliedCommand(COMMAND_STOP_SPINDLE);
  writeBlock(mFormat.format(30)); // stop program, spindle stop, coolant off

}

function setProperty(property, value) {
  properties[property].current = value;
}
// <<<<< INCLUDED FROM ../common/mazak integrex i.cps
properties.maximumSpindleSpeed.value = 6000;
