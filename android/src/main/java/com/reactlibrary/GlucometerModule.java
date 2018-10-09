package com.reactlibrary;



import com.cooey.glucometer.GlucometerController;
import com.cooey.glucometer.IGlucometerResultCallBack;


import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;

public class GlucometerModule extends ReactContextBaseJavaModule implements IGlucometerResultCallBack {

    private final ReactApplicationContext reactContext;
    private GlucometerController glucometerController;

    public GlucometerModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
        this.glucometerController = new GlucometerController(this.reactContext, this);
    }

    @ReactMethod
    public void startMeasuring(Integer testType) {
        this.glucometerController.startMeasuring(this.reactContext);
    }

    @ReactMethod
    public void stopMeasuring() {
    this.glucometerController.stopMeasuring();
    }

    @Override
    public String getName() {
        return "Glucometer";
    }



    @Override
    public void onDeviceNotInserted() {
        WritableMap params = Arguments.createMap();
        params.putString("status","plugged_out");
        RNCooeyModule.sendEvent(this.reactContext,"gluco_device_connection",params);
    }

    @Override
    public void onDeviceRecognised() {
        WritableMap params = Arguments.createMap();
        params.putString("status","recognized");
        RNCooeyModule.sendEvent(this.reactContext,"gluco_device_connection",params);
    }

    @Override
    public void onTestPaperInserted() {
        WritableMap params = Arguments.createMap();
        params.putString("status","readyToTest");
        RNCooeyModule.sendEvent(this.reactContext,"gluco_device_connection",params);

    }

    @Override
    public void onOldTestPaperInserted() {

        WritableMap params = Arguments.createMap();
        params.putString("status","old_paper_user");
        RNCooeyModule.sendEvent(this.reactContext,"gluco_device_connection",params);
    }

    @Override
    public void onTestPaperRemoved() {

        WritableMap params = Arguments.createMap();
        params.putString("status","paper_out");
        RNCooeyModule.sendEvent(this.reactContext,"gluco_device_connection",params);
    }

    @Override
    public void onTestStarted() {
        WritableMap params = Arguments.createMap();
        params.putInt("progress",1);
        RNCooeyModule.sendEvent(this.reactContext,"gluco_test_progress",params);
    }

    @Override
    public void onTestFinished(float result) {
        WritableMap params = Arguments.createMap();
        params.putDouble("result",result);
        RNCooeyModule.sendEvent(this.reactContext,"gluco_test_result",params);
    }

    @Override
    public void onLowVoltage() {
        this.onError();
    }

    @Override
    public void onCalibrationFailed() {
       this.onError();
    }

    @Override
    public void onLowTemperature() {
        this.onError();
    }

    @Override
    public void onHighTemperature() {
        this.onError();
    }

    @Override
    public void onPlayAudioError() {
        this.onError();
    }

    @Override
    public void onRecordAudioError() {
        this.onError();
    }

    @Override
    public void onRecognitionError() {
        this.onError();
    }

    @Override
    public void onTimeOutError() {
        this.onError();
    }

    @Override
    public void onCommunicating() {
        WritableMap params = Arguments.createMap();
        params.putString("status","old_paper_used");
        RNCooeyModule.sendEvent(this.reactContext,"gluco_device_connection",params);
    }

    @Override
    public void onRecognising() {
        WritableMap params = Arguments.createMap();
        params.putString("status","recognized");
        RNCooeyModule.sendEvent(this.reactContext,"gluco_device_connection",params);
    }

    private void onError() {
        WritableMap params = Arguments.createMap();
        params.putString("status","communicating");
        RNCooeyModule.sendEvent(this.reactContext,"gluco_device_connection",params);
    }
}
