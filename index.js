const { NativeModules, NativeEventEmitter } = require('react-native');

const { Cooey } = NativeModules;

const CooeyEvents = new NativeEventEmitter(Cooey);
const VoiceBPMonitor = NativeModules.VoiceBPMonitor
const Glucometer = NativeModules.Glucometer
const WeighingScale = NativeModules.WeighingScale

module.exports = {
    VoiceBPMonitor,
    Glucometer,
    WeighingScale,
    CooeyEvents
};
