
package com.reactlibrary;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.cooey.devices.CooeyDeviceManager;

public class RNCooeyModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;

  public RNCooeyModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
    CooeyDeviceManager.getInstance();

  }

  @Override
  public String getName() {
    return "RNCooey";
  }
}