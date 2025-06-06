import { Descriptor, RNOHContext, RNViewBase, ViewBaseProps } from '@rnoh/react-native-openharmony';

interface ImageConfigProps {
  source?: string;
  width?: number | string;
  height?: number | string;
  resizeMode?: string;
  radius?: number;
  opacity?: number;
  offset?: Position;
}

export const SHADOW_IMAGE_NAME: string = "ShadowImage";

export interface ShadowImageProps extends ViewBaseProps {
  ImageConfig: ImageConfigProps,
}

export type ShadowImageDescriptor = Descriptor<"ShadowImage", ShadowImageProps>;

@Component
export struct ShadowImage {
  ctx!: RNOHContext
  tag: number = 0;
  @State ImageConfig: ImageConfigProps = {};
  private unregisterDescriptorChangesListener?: () => void = undefined;
  @State private descriptor: ShadowImageDescriptor = {} as ShadowImageDescriptor;

  aboutToAppear(): void {
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<ShadowImageDescriptor>(this.tag);

    this.unregisterDescriptorChangesListener =
      this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag, (newDescriptor) => {
        this.descriptor = (newDescriptor as ShadowImageDescriptor)
      });

    console.log("ShadowImage rawProps = ", JSON.stringify(this.descriptor.rawProps), this.tag);
    console.log("ShadowImage props = ", JSON.stringify(this.descriptor.props), this.tag);
    this.ImageConfig = (this.descriptor.rawProps as ShadowImageProps).ImageConfig;

    // 监听rn侧的事件消息
    this.ctx.componentCommandReceiver.registerCommandCallback(this.tag, (commandName: string, args: string[]) => {
      if (args.length == 0) {
        return;
      }
    })
  }

  // 页面销毁监听
  aboutToDisappear(): void {
    this.unregisterDescriptorChangesListener?.();
  }

  // 获取图片缩放模式
  getImageMode(resizeMode?: string): ImageFit {
    switch (resizeMode) {
      case 'contain':
        return ImageFit.Contain;
      case 'cover':
        return ImageFit.Cover;
      case 'auto':
        return ImageFit.Auto;
      case 'fill':
        return ImageFit.Fill;
      default:
        return ImageFit.Contain
    }
  }

  build() {
    RNViewBase({ ctx: this.ctx, tag: this.tag }) {
      Stack() {
        Image($rawfile(`assets/src/assets/${this.ImageConfig.source}`))
          .width(this.ImageConfig.width)
          .height(this.ImageConfig.height)
          .objectFit(this.getImageMode(this.ImageConfig.resizeMode))
          .draggable(false)
      }
      .width('100%')
    }
  }
}