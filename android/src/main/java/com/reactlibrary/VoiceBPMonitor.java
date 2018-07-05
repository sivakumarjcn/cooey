package com.reactlibrary;

import android.app.Application;
import android.support.v7.app.AppCompatDelegate;
import android.util.Log;

import com.cooey.devices.bpmeter.VoiceBpMeterCallBack;
import com.cooey.devices.bpmeter.VoiceBpMeterControls;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;


public class VoiceBPMonitor implements VoiceBpMeterCallBack {

    private final ReactContext context;
    private VoiceBpMeterControls voiceBpMeterControls;
    private Boolean mConnected = false;

    public VoiceBPMonitor(ReactContext context) {
        this.context = context;

    }


    @ReactMethod
    public void initializeDevice() {
        //Inititalize the voicebpmeter with context and callback interface
        this.voiceBpMeterControls = new VoiceBpMeterControls(context, this);
        //Enable scan of the voice bp meter
        mConnected = this.voiceBpMeterControls.scanLeDevice(true);
    }

    @ReactMethod
    public void connect() {
        if(mConnected) {
            this.voiceBpMeterControls.takeReading();
        }else  {
            mConnected = this.voiceBpMeterControls.scanLeDevice(true);

        }
    }

    @Override
    public void onDeviceConnected(boolean b) {
        WritableMap params = Arguments.createMap();
        params.putBoolean("connected", b);
        this.sendEvent("voice_bp_connected", params);
    }

    @Override
    public void batteryStatus(String s) {

    }

    @Override
    public void onProgressSystolicValue(String s) {

    }

    @Override
    public void onDeviceResults(int systolic, int diastolic, int heartRate) {

    }

    @Override
    public void onError(String s) {

    }

    public void sendEvent(final String eventName, final WritableMap params) {
        if (this.context.hasActiveCatalystInstance()) {
            this.context
                    .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                    .emit(eventName, params);
        } else {
            Log.d("VoiceBPMonitor", "Waiting for CatalystInstance before sending event");
        }
    }
}
