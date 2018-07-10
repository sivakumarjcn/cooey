const { NativeModules, NativeEventEmitter } = require('react-native');

const { Cooey } = NativeModules;

const CooeyEvents = new NativeEventEmitter(Cooey);
const VoiceBPMonitor = Cooey.VoiceBPMonitor

export default {
    VoiceBPMonitor,
    CooeyEvents
};
