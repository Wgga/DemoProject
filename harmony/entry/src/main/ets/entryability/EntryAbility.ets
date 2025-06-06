import { RNAbility } from '@rnoh/react-native-openharmony';

import { display, router, window } from '@kit.ArkUI';
import { Want } from '@kit.AbilityKit';
import { BusinessError, deviceInfo } from '@kit.BasicServicesKit';

import { SplashScreen } from '../model/SplashScreen';
import { MMKV } from '@tencent/mmkv';

export default class EntryAbility extends RNAbility {
  onCreate(want: Want) {
    super.onCreate(want)
    let appCtx = this.context.getApplicationContext();
    MMKV.initialize(appCtx);
  }

  getPagePath() {
    return 'pages/Index';
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    super.onWindowStageCreate(windowStage);
    // 设置启动页图片
    SplashScreen.setSplashImage();
    // 设置设备屏幕方向
    windowStage.getMainWindow().then((windowObj: window.Window) => {
      this.setWindowOrientation(windowObj, display.getFoldStatus());
      // 监听折叠屏的展开态/折叠态设置屏幕方向
      display.on("foldStatusChange", (foldStatus: display.FoldStatus) => {
        this.setWindowOrientation(windowObj, foldStatus);
      })
    })
    // 获取设备安全区域距离
    windowStage.loadContent(this.getPagePath(), (err) => {
      if (err.code) {
        return;
      }
      // 获取应用主窗口
      let windowClass: window.Window = windowStage.getMainWindowSync();
      // 1. 设置窗口全屏
      windowClass.setWindowLayoutFullScreen(true);

      // 2. 获取布局避让遮挡的区域
      // 获取顶部状态栏区域的高度
      let type = window.AvoidAreaType.TYPE_SYSTEM;
      let avoidArea = windowClass.getWindowAvoidArea(type);
      let topRectHeight = avoidArea.topRect.height;
      AppStorage.setOrCreate('topRectHeight', px2vp(topRectHeight));
      // 获取底部导航条区域的高度
      type = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR;
      avoidArea = windowClass.getWindowAvoidArea(type);
      let bottomRectHeight = avoidArea.bottomRect.height;
      AppStorage.setOrCreate('bottomRectHeight', px2vp(bottomRectHeight));

      // 3. 注册监听函数，动态获取避让区域数据
      windowClass.on('avoidAreaChange', (data) => {
        if (data.type === window.AvoidAreaType.TYPE_SYSTEM) {
          let topRectHeight = data.area.topRect.height;
          AppStorage.setOrCreate('topRectHeight', px2vp(topRectHeight));
        } else if (data.type == window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
          let bottomRectHeight = data.area.bottomRect.height;
          AppStorage.setOrCreate('bottomRectHeight', px2vp(bottomRectHeight));
        }
      });

      // 监听可视区域变化获取设备宽度
      windowClass.on("windowSizeChange", (size: window.Size) => {
        AppStorage.setOrCreate('screenWidth', px2vp(size.width));
        AppStorage.setOrCreate('screenHeight', px2vp(size.height));
      })
    })
  }

  // 设置设备屏幕方向
  private setWindowOrientation(windowObj: window.Window, foldStatus: display.FoldStatus) {
    // 判断是否为折叠屏的展开态/平板设备
    const isExpandedOrTablet: boolean =
      (foldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED || deviceInfo.deviceType == "tablet");
    const orientation: window.Orientation =
      isExpandedOrTablet ? window.Orientation.AUTO_ROTATION_RESTRICTED : window.Orientation.PORTRAIT;
    try {
      windowObj?.setPreferredOrientation(orientation, (err: BusinessError) => {
        if (err.code) {
          console.error(`Failed to set window orientation. Cause code: ${err.code}, message: ${err.message}`);
          return;
        }
        console.info("Succeeded in setting window orientation.");
      });
    } catch (exception) {
      console.error(`Failed to set window orientation. Cause code: ${exception.code}, message: ${exception.message}`);
    }
  }
}