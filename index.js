
import { NativeModules, NativeEventEmitter } from 'react-native';

const { RNCooey } = NativeModules;

const CooeyEvents = new NativeEventEmitter(RNCooey);
const VoiceBPMonitor = RNCooey.VoiceBPMonitor

export default {
    VoiceBPMonitor,
    CooeyEvents
};
