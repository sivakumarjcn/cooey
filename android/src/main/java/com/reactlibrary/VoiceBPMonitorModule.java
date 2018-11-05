package com.reactlibrary;


import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;

import com.cooey.android.voicebp.VoiceBpMeterCallBack;
import com.cooey.android.voicebp.VoiceBpMeterControls;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;



public class VoiceBPMonitorModule extends ReactContextBaseJavaModule implements VoiceBpMeterCallBack, ActivityEventListener {

    private final ReactApplicationContext reactContext;
    private VoiceBpMeterControls voiceBpMeterControls;
    private Boolean mConnected = false;
    private BluetoothAdapter bluetoothAdapter;
    private final static int REQUEST_ENABLE_BT = 1;


    public VoiceBPMonitorModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
        this.reactContext.addActivityEventListener(this);
        final BluetoothManager bluetoothManager =
                (BluetoothManager) this.reactContext.getSystemService(Context.BLUETOOTH_SERVICE);
        bluetoothAdapter = bluetoothManager.getAdapter();
    }


    @ReactMethod
    public void connectBPMonitor() {
        this.startConnection();

    }

    private void  startConnection() {
        //Inititalize the voice bp meter with context and callback interface
        try {

            if (bluetoothAdapter == null || !bluetoothAdapter.isEnabled()) {
                Intent enableBtIntent =
                        new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
                final Activity activity = getCurrentActivity();
                activity.startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);

            }else {
                this.voiceBpMeterControls = new VoiceBpMeterControls(this.reactContext, this);
                //Enable scan of the voice bp meter
                mConnected = this.voiceBpMeterControls.scanLeDevice(true);
            }

        }catch (Exception e) {
            WritableMap params = Arguments.createMap();
            params.putString("error",e.getLocalizedMessage());
            RNCooeyModule.sendEvent(this.reactContext,"voice_bp_error",params);
        }


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
    

    @Override
    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
        if(requestCode == REQUEST_ENABLE_BT) {
            if (resultCode == Activity.RESULT_CANCELED) {
                WritableMap params = Arguments.createMap();
                params.putString("error","bluetooth permission denied");
                RNCooeyModule.sendEvent(this.reactContext,"voice_bp_error",params);
            }else {
                this.startConnection();
            }
        }
    }

    @Override
    public void onNewIntent(Intent intent) {

    }
}
