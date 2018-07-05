
package com.reactlibrary;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;



public class RNCooeyModule extends ReactContextBaseJavaModule  {


  private final ReactApplicationContext reactContext;
  private VoiceBPMonitor bpMonitor;

  public RNCooeyModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
    this.bpMonitor = new VoiceBPMonitor(reactContext);
  }

  @Override
  public String getName() {
    return "RNCooey";
  }

}