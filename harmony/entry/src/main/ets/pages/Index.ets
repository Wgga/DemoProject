import {
  AnyJSBundleProvider,
  ComponentBuilderContext,
  FileJSBundleProvider,
  MetroJSBundleProvider,
  ResourceJSBundleProvider,
  RNApp,
  RNOHErrorDialog,
  RNOHLogger,
  TraceJSBundleProviderDecorator,
  RNOHCoreContext
} from '@rnoh/react-native-openharmony'
import { ImmersiveMode, LevelMode } from '@kit.ArkUI'
import { createRNPackages } from '../RNPackagesFactory'
import { SplashScreenPage } from './SplashScreenPage'
import { SplashDataProps, SplashScreen } from '../model/SplashScreen'
import StorageUtils from '../utils/StorageUtils'

@Builder
export function buildCustomRNComponent(ctx: ComponentBuilderContext) {
}

const wrappedCustomRNComponentBuilder = wrapBuilder(buildCustomRNComponent)

const arkTsComponentNames: Array<string> = [
]
const fonts: Record<string, Resource> = {
  // "iconfont": $rawfile("fonts/iconfont.ttf")
}

@Entry
@Component
struct Index {
  @StorageLink('RNOHCoreContext') private rnohCoreContext: RNOHCoreContext | undefined = undefined
  @State shouldShow: boolean = false
  @StorageProp("screenHeight") screenHeight: number = 0; // 设备宽度
  @StorageProp("topRectHeight") topRectHeight: number = 0; // 顶部安全距离
  private logger!: RNOHLogger
  private uiContext: UIContext = this.getUIContext();

  @Builder
  Splash() {
    SplashScreenPage()
  }

  aboutToAppear(): void {
    this.logger = this.rnohCoreContext!.logger.clone("Index")
    const stopTracing = this.logger.clone("aboutToAppear").startTracing()

    this.shouldShow = true
    stopTracing()
    this.showSplash();
  }

  /**
   * 打开启动页
   */
  showSplash() {
    this.uiContext.getPromptAction().openCustomDialog({
      builder: () => this.Splash(),
      alignment: DialogAlignment.Bottom,
      autoCancel: false,
      isModal: false,
      width: '100%',
      height: this.screenHeight,
      cornerRadius: 0,
      transition: TransitionEffect.OPACITY.animation({ duration: 300 }),
      offset: { dx: 0, dy: -this.topRectHeight },
      levelMode: LevelMode.OVERLAY, // 启用页面级弹出框
      immersiveMode: ImmersiveMode.EXTEND, // 设置页面级弹出框蒙层的显示模式
    }).then((dialogId: number) => this.closeSplash(dialogId))
  }

  /**
   * 延时关闭启动页
   */
  closeSplash(dialogId: number): void {
    setTimeout(() => {
      this.uiContext.getPromptAction().closeCustomDialog(dialogId);
      SplashScreen.cacheSplashImage();
    }, SplashScreen.duration);
  }

  onBackPress(): boolean | undefined {
    // NOTE: this is required since `Ability`'s `onBackPressed` function always
    // terminates or puts the app in the background, but we want Ark to ignore it completely
    // when handled by RN
    this.rnohCoreContext!.dispatchBackPress()
    return true
  }

  build() {
    Column() {
      if (this.rnohCoreContext && this.shouldShow) {
        if (this.rnohCoreContext?.isDebugModeEnabled) {
          RNOHErrorDialog({ ctx: this.rnohCoreContext })
        }
        RNApp({
          rnInstanceConfig: {
            createRNPackages,
            enableNDKTextMeasuring: true, // 该项必须为true，用于开启NDK文本测算
            enableBackgroundExecutor: false,
            enableCAPIArchitecture: true, // 该项必须为true，用于开启CAI
            arkTsComponentNames: arkTsComponentNames,
            fontResourceByFontFamily: fonts,
          },
          initialProps: { "foo": "bar" } as Record<string, string>,
          appKey: "DemoProject",
          wrappedCustomRNComponentBuilder: wrappedCustomRNComponentBuilder,
          onSetUp: (rnInstance) => {
            rnInstance.enableFeatureFlag("ENABLE_RN_INSTANCE_CLEAN_UP")
          },
          jsBundleProvider: new TraceJSBundleProviderDecorator(
            new AnyJSBundleProvider([
              new MetroJSBundleProvider(),
              // NOTE: to load the bundle from file, place it in
              // `/data/app/el2/100/base/com.rnoh.tester/files/bundle.harmony.js`
              // on your device. The path mismatch is due to app sandboxing on HarmonyOS
              new FileJSBundleProvider('/data/storage/el2/base/files/bundle.harmony.js'),
              new ResourceJSBundleProvider(this.rnohCoreContext.uiAbilityContext.resourceManager, 'hermes_bundle.hbc'),
              new ResourceJSBundleProvider(this.rnohCoreContext.uiAbilityContext.resourceManager, 'bundle.harmony.js')
            ]),
            this.rnohCoreContext.logger),
        })
      }
    }
    .height('100%')
    .width('100%')
  }
}