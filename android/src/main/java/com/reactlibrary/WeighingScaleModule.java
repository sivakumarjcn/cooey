package com.reactlibrary;

import android.Manifest;
import android.app.Activity;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.cooey.com.weighingscale.CooeyBleDeviceManager;
import android.cooey.com.weighingscale.STATE;
import android.cooey.com.weighingscale.UserInfo;
import android.cooey.com.weighingscale.WeighingScaleCallBack;
import android.os.Build;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;

import org.jetbrains.annotations.NotNull;

public class WeighingScaleModule extends ReactContextBaseJavaModule implements  WeighingScaleCallBack {

    private final ReactApplicationContext reactContext;

    private BluetoothManager mBluetoothManager;

    private final static int REQUEST_ENABLE_BT = 1;
    private CooeyBleDeviceManager cooeyBleDeviceManager;
    private int age;
    private int gender;
    private float height;

    public WeighingScaleModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;

    }

    @Override
    public String getName() {
        return "WeighingScale";
    }

    @ReactMethod
    public void pairDevice(ReadableMap userData) {
        this.age = userData.getInt("age");
        this.gender = userData.getInt("gender");
        this.height = (float) userData.getDouble("height");
        String sexType = this.gender == 1 ? "MALE" : "FEMALE";
        UserInfo info = new UserInfo(sexType, age, height);
        this.cooeyBleDeviceManager = new CooeyBleDeviceManager(this.reactContext, info, WeighingScaleModule.this);
        this.getPermissions();
    }

    @ReactMethod void takeReading(ReadableMap userData) {
        this.age = userData.getInt("age");
        this.gender = userData.getInt("gender");
        this.height = (float) userData.getDouble("height");
        this.startScan();
    }


    @ReactMethod void stopDevice() {
        if(cooeyBleDeviceManager!=null){
            cooeyBleDeviceManager.stopSearch();
            cooeyBleDeviceManager.disconnect();
        }
    }




    protected void getPermissions() {
        if (Build.VERSION.SDK_INT >= 23) {
            if (ContextCompat.checkSelfPermission(this.reactContext, Manifest.permission.BLUETOOTH) ==
                    PackageManager.PERMISSION_GRANTED &&
                    ContextCompat.checkSelfPermission(this.reactContext,
                            Manifest.permission.ACCESS_FINE_LOCATION)
                            == PackageManager.PERMISSION_GRANTED) {
                startScan();
            } else {
                String[] permissions = {Manifest.permission.BLUETOOTH,
                        Manifest.permission.ACCESS_FINE_LOCATION};
                ActivityCompat.requestPermissions(this.getCurrentActivity(), permissions, REQUEST_ENABLE_BT);
            }
        } else {
            turnOnBluetooth();
        }
    }



    private void startScan() {
        cooeyBleDeviceManager.initialize(this.reactContext);
        cooeyBleDeviceManager.startSearch();
    }


    private void turnOnBluetooth() {
        if (mBluetoothManager == null) {
            mBluetoothManager = (BluetoothManager) this.reactContext.getSystemService(Context.BLUETOOTH_SERVICE);
        }
        try {
            BluetoothAdapter bluetoothAdapter  = mBluetoothManager.getAdapter();
            bluetoothAdapter.enable();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }



    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {

        if(requestCode == REQUEST_ENABLE_BT) {
            if (resultCode == Activity.RESULT_CANCELED) {
                WritableMap params = Arguments.createMap();
                params.putString("bluetooth_error","bluetooth permission denied");
                RNCooeyModule.sendEvent(this.reactContext,"wt_connectionStatus",params);
            }else {
                this.turnOnBluetooth();
                this.startScan();
            }
        }
    }

    @Override
    public void error(String s) {
        WritableMap params = Arguments.createMap();
        params.putString("status",s);
        RNCooeyModule.sendEvent(this.reactContext,"wt_connectionStatus",params);
    }

    @Override
    public void getValue(final double weight,
                         @NotNull String unit,
                         float basalMetabolism,
                         float bodyFatRatio,
                         float bodyWaterRatio,
                         float visceralFatLevel,
                         float muscleMassRatio,
                         float boneDensity) {

        WritableMap params = Arguments.createMap();
        params.putDouble("weight", weight);
        params.putDouble("fatPercent", bodyFatRatio);
        params.putDouble("waterPercent", bodyWaterRatio);
        params.putDouble("musclePercent", muscleMassRatio);
        params.putDouble("bonePercent", boneDensity);

        RNCooeyModule.sendEvent(this.reactContext,"weighingScaleResult",params);
    }

    @Override
    public void state(STATE state) {
        WritableMap params = Arguments.createMap();
        String status =  "SEARCHING";
        if(state == STATE.PAIRING) {
            status = "PAIRING";
        }else if(state == STATE.TAKING_READING) {
            status = "TAKING_READING";
        }

        params.putString("status", status);
        RNCooeyModule.sendEvent(this.reactContext,"wt_readingStatus",params);
    }
}
