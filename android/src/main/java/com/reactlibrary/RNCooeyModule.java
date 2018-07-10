
package com.reactlibrary;

import android.util.Log;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;


public class RNCooeyModule extends ReactContextBaseJavaModule {


  private final ReactApplicationContext reactContext;

  public RNCooeyModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "RNCooey";
  }

  public static void sendEvent(final ReactContext context,
                               final String eventName,
                               final WritableMap params) {
    if (context.hasActiveCatalystInstance()) {
      context
              .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
              .emit(eventName, params);
    } else {
      Log.d("CooeyModule", "Waiting for CatalystInstance before sending event");
    }
  }
}