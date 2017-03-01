package com.ismaeld;

import android.bluetooth.BluetoothAdapter;
import android.provider.Settings;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;

public class RNStateModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;

  public RNStateModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "RNState";
  }

  @ReactMethod
  public void isBluetoothEnabled(Promise promise) {
    try {
      boolean result = BluetoothAdapter.getDefaultAdapter().isEnabled();
      promise.resolve(result);
    } catch (Exception e) {
      promise.reject(e);
    }
  }

  @ReactMethod
  public void isLocationEnabled(Promise promise) {
    try {
      boolean result = getLocationMode() == Settings.Secure.LOCATION_MODE_OFF ? false : true;
      promise.resolve(result);
    } catch (Exception e) {
      promise.reject(e);
    }
  }

  @ReactMethod
  public void isLocationAuthorized(Promise promise) {
    try {
      promise.resolve(true);
    } catch (Exception e) {
      promise.reject(e);
    }
  }

  private int getLocationMode() throws Exception {
    int mode = Settings.Secure.getInt(this.reactContext.getContentResolver(), Settings.Secure.LOCATION_MODE);
    return mode;
  }

}
