package com.reactlibrary;

import android.os.Handler;
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
    public void initiateVoiceBP() {
        //Inititalize the voicebpmeter with context and callback interface
        this.voiceBpMeterControls = new VoiceBpMeterControls(context, this);
        //Enable scan of the voice bp meter
        mConnected = this.voiceBpMeterControls.scanLeDevice(true);
    }

    @ReactMethod
    public void connectBPMonitor() {
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
        params.putBoolean("connected", b);
        this.sendEvent("voice_bp_connected", params);
    }

    @Override
    public void batteryStatus(String s) {
        WritableMap params = Arguments.createMap();
        params.putString("status",s);
        this.sendEvent("voice_bp_battery", params);
    }

    @Override
    public void onProgressSystolicValue(String s) {
        WritableMap params = Arguments.createMap();
        params.putString("status",s);
        this.sendEvent("voice_bp_sys_progress",params);

    }

    @Override
    public void onDeviceResults(int systolic, int diastolic, int heartRate) {
        WritableMap params = Arguments.createMap();
        params.putInt("systolic",systolic);
        params.putInt("diastolic",diastolic);
        params.putInt("heartRate",heartRate);
        this.sendEvent("voice_bp_results",params);
    }

    @Override
    public void onError(String s) {
        WritableMap params = Arguments.createMap();
        params.putString("error",s);
        this.sendEvent("voice_bp_error",params);
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
