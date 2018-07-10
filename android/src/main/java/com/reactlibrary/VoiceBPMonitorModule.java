package com.reactlibrary;

import android.os.Handler;
import com.cooey.devices.bpmeter.VoiceBpMeterCallBack;
import com.cooey.devices.bpmeter.VoiceBpMeterControls;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;


public class VoiceBPMonitorModule extends ReactContextBaseJavaModule implements VoiceBpMeterCallBack {

    private final ReactApplicationContext reactContext;
    private VoiceBpMeterControls voiceBpMeterControls;
    private Boolean mConnected = false;

    public VoiceBPMonitorModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
        //Inititalize the voice bp meter with context and callback interface
        this.voiceBpMeterControls = new VoiceBpMeterControls(this.getReactApplicationContext(), this);
    }


    @ReactMethod
    public void connectBPMonitor() {
        //Enable scan of the voice bp meter
        mConnected = this.voiceBpMeterControls.scanLeDevice(true);
    }

    @ReactMethod
    public void takeReading() {
        if(mConnected) {
            this.voiceBpMeterControls.takeReading();
        }else  {
            mConnected = this.voiceBpMeterControls.scanLeDevice(true);
            final Handler handler = new Handler();
            handler.postDelayed(new Runnable() {
                @Override
                public void run() {
                        if(voiceBpMeterControls != null) {
                            voiceBpMeterControls.takeReading();
                        }

                }
            }, 1000);
        }
    }

    @Override
    public void onDeviceConnected(boolean b) {
        WritableMap params = Arguments.createMap();
        params.putBoolean("status", b);
        RNCooeyModule.sendEvent(this.reactContext,"voice_bp_connection", params);
    }

    @Override
    public void batteryStatus(String s) {
        WritableMap params = Arguments.createMap();
        params.putString("status",s);
        RNCooeyModule.sendEvent(this.reactContext,"voice_bp_battery", params);
    }

    @Override
    public void onProgressSystolicValue(String s) {
        WritableMap params = Arguments.createMap();
        params.putString("progress",s);
        RNCooeyModule.sendEvent(this.reactContext,"voice_bp_sys_progress",params);

    }

    @Override
    public void onDeviceResults(int systolic, int diastolic, int heartRate) {
        WritableMap params = Arguments.createMap();
        params.putInt("systolic",systolic);
        params.putInt("diastolic",diastolic);
        params.putInt("heartRate",heartRate);
        RNCooeyModule.sendEvent(this.reactContext,"voice_bp_results",params);
    }

    @Override
    public void onError(String s) {
        WritableMap params = Arguments.createMap();
        params.putString("error",s);
        RNCooeyModule.sendEvent(this.reactContext,"voice_bp_error",params);
    }



    @Override
    public String getName() {
        return "VoiceBPMonitor";
    }
}
