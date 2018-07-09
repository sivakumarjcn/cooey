package com.reactlibrary;

import android.os.Handler;
import android.util.Log;

import com.cooey.devices.bpmeter.VoiceBpMeterCallBack;
import com.cooey.devices.bpmeter.VoiceBpMeterControls;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;


public class VoiceBPMonitorModule extends ReactContextBaseJavaModule implements VoiceBpMeterCallBack {

    private final ReactApplicationContext reactContext;
    private VoiceBpMeterControls voiceBpMeterControls;
    private Boolean mConnected = false;

    public VoiceBPMonitorModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }


    @ReactMethod
    public void connectBPMonitor() {
        //Inititalize the voice bp meter with context and callback interface
        this.voiceBpMeterControls = new VoiceBpMeterControls(this.getReactApplicationContext(), this);
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
        if (this.reactContext.hasActiveCatalystInstance()) {
            this.reactContext
                    .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                    .emit(eventName, params);
        } else {
            Log.d("VoiceBPMonitorModule", "Waiting for CatalystInstance before sending event");
        }
    }

    @Override
    public String getName() {
        return "VoiceBPMonitor";
    }
}
