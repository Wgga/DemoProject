import { ImageKnifeComponent, ImageKnifeOption } from "@ohos/imageknife";
import { SplashScreen } from "../model/SplashScreen";

@Component
export struct SplashScreenPage {
  @State option: ImageKnifeOption = {
    loadSrc: SplashScreen.splashUrl,
    objectFit: ImageFit.Cover,
  }

  build() {
    Row() {
      ImageKnifeComponent({
        imageKnifeOption: this.option,
      })
    }
    .width('100%')
    .height('100%')
  }
}
