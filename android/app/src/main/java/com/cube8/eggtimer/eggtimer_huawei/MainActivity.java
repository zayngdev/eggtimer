package com.cube8.eggtimer.eggtimer_huawei;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

import com.huawei.android.sdk.drm.Drm;
import com.huawei.android.sdk.drm.DrmCheckCallback;

public class MainActivity extends FlutterActivity {

  // 版权保护id
  private static final String DRM_ID = "890086200300013636";
  // 版权保护公钥
  private static final String DRM_PUBLIC_KEY = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoCwYi/QGLO+bcD05S6aKKPVdcBDowmx23eyvdMzLiYrpOYjYCQ5GqqPY2G5PxVWZMjIgbGHrdOBeJfc3Qriv+jhmcluKRA5/GeqLfV1ay5uqRlhArs3G8qmmZuaBOLCeLOuTaY4WXrcDOqPf62WozsHqF2M3CvwjmioQa9cpSVAm3/ikBLcqpT6xUjvbLw2STJeuF2nwlnbE7qjrAX/XW1OYKR7UklMscgAeFOAEyChGBuKc5KfZyFBak/WiCblShs24GEph0PyNlpFxF8Oh/zD6DBTcfacay9OlR7pVecwGM80ZgFy6WUO+tBI4EtIQqofknQr0cgSSPCESxEO/6QIDAQAB";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    // 调用鉴权方法
    Drm.check(this, this.getPackageName(), DRM_ID, DRM_PUBLIC_KEY,
            new MyDrmCheckCallback());
  }

  /**
   * 鉴权结果处理回调接口
   */
  private class MyDrmCheckCallback implements DrmCheckCallback {

    @Override
    public void onCheckSuccess() {
      // 鉴权成功，用户继续使用程序。
      //setContentView(R.layout.activity_second);
    }

    @Override
    public void onCheckFailed() {
      // 鉴权失败，用户不能使用程序，程序退出。
      finish();
    }
  }
}
