
package com.reactlibrary;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;


public class RNCooeyModule extends ReactContextBaseJavaModule  {


  private final ReactApplicationContext reactContext;
  private VoiceBPMonitorModule bpMonitor;

  public RNCooeyModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "RNCooey";
  }


}