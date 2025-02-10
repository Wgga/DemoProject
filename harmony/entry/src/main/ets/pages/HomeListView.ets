import { display, LengthMetrics } from "@kit.ArkUI";
import { Descriptor, RNOHContext, RNViewBase, ViewBaseProps } from "@rnoh/react-native-openharmony";

interface BannerProps {
  id: string;
  title: string;
}

interface KnowledgeProps {
  id: string;
  pic: string;
  title: string;
  title2: string;
  title3: string;
}

interface ArticleItemProps {
  id: string;
  pic: string;
  title: string;
  title2: string;
  title3: string;
  desc: string;
}

interface TopicItemProps {
  cnt: string;
  dlgid: string;
  id: string;
  title: string;
}

interface VodItemProps {
  name: string;
  viid: string;
  vpicurl: string;
  main_tit?: string;
  sub_tit?: string;
}

interface headerDataProps {
  banner: BannerProps[];
  knowledgeitems: KnowledgeProps[];
  newitem: ArticleItemProps;
  smellitems: ArticleItemProps[];
  topiclist: TopicItemProps[];
  newVodItem: VodItemProps;
  hotVodItems: VodItemProps[];
}

interface ListArrProps {
  data: ListItemProps[];
}

interface ListItemProps {
  favcnt: string;
  id: string;
  pic: string;
  replycnt: string;
  title: string;
}

interface offsetProps {
  left: number;
  scale: number;
  zIndex: number;
  opacity: number;
}

export interface HomeListViewProps extends ViewBaseProps {
  src: string,
  contentHeight: string,
  headerData: headerDataProps,
  tabData: string[],
}

// 文章列表懒加载数据
class ArticleListData implements IDataSource {
  private dataArray: ListItemProps[];
  private listeners: DataChangeListener[] = [];

  constructor(dataArray: ListItemProps[]) {
    this.dataArray = dataArray;
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): ListItemProps {
    return this.dataArray[index];
  }

  public concatData(data: ListItemProps[]): void {
    data.forEach((item: ListItemProps) => {
      this.dataArray.push(item);
    })
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }
}

export type HomeListViewDescriptor = Descriptor<"HomeListView", HomeListViewProps>;

function displayWidth():number {
  let displayClass: display.Display = display.getDefaultDisplaySync();
  return px2vp(displayClass?.width)
}

@Component
export struct HomeListView {
  static NAME: string = "HomeListView"
  ctx!: RNOHContext
  tag: number = 0
  private unregisterDescriptorChangesListener?: () => void = undefined
  @State private descriptor: HomeListViewDescriptor = {} as HomeListViewDescriptor

  @StorageProp('topRectHeight')
  topRectHeight: number = 0; // 顶部安全距离
  @StorageProp('homeSwiperHeight')
  homeSwiperHeight: number = 0; // 顶部轮播图高度
  @StorageProp('homeHeaderHeight')
  homeHeaderHeight: number = 0; // 顶部容器高度
  @StorageProp('homeSearchHeight')
  homeSearchHeight: number = 0; // 顶部搜索框高度

  @State src: string = "" // 和props里的src绑定
  @State contentHeight: string = ""
  @State banner: BannerProps[] = []
  @State tabData: string[] = [] // tab数据
  @State listData: ArticleListData[] = [] // 列表数据
  @State listOffset: number[] = [0, 0, 0, 0] // 列表偏移量数据
  @State currentIndex: number = 0 // 当前tab索引
  private scrollerForScroll: Scroller = new Scroller() // 外层滚动实例
  private scrollerForLists: ListScroller[] = [
    new ListScroller(),
    new ListScroller(),
    new ListScroller(),
    new ListScroller()
  ] // 内层滚动实例
  private tabController: TabsController = new TabsController() // tab实例

  aboutToAppear() {
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<HomeListViewDescriptor>(this.tag)

    this.unregisterDescriptorChangesListener = this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag, (newDescriptor) => {
      this.descriptor = (newDescriptor as HomeListViewDescriptor)
    })

    console.log('HomeListView rawProps = ', JSON.stringify(this.descriptor.rawProps), this.tag)
    console.log('HomeListView props = ', JSON.stringify(this.descriptor.props), this.tag)
    this.src = (this.descriptor.rawProps as HomeListViewProps).src
    this.contentHeight = (this.descriptor.rawProps as HomeListViewProps).contentHeight
    this.tabData = (this.descriptor.rawProps as HomeListViewProps).tabData

    this.ctx.rnInstance.emitComponentEvent(
      this.descriptor.tag,
      "loadEnd",
      { isLoaded: true }
    )

    // 监听rn侧的事件消息
    this.ctx.componentCommandReceiver.registerCommandCallback(this.tag, (commandName: string, args: string[]) => {
      if (args.length == 0) return;
      if (commandName === "setArticleListData") { // 设置文章列表数据
      } else if (commandName === "loadMoreArticleListData") { // 加载下一页数据
      }
    })
  }

  aboutToDisappear() {
    this.unregisterDescriptorChangesListener?.()
  }

  // 跳转页面
  gotoDetail(id: string) {
    this.ctx.rnInstance.emitComponentEvent(
      this.descriptor.tag,
      "gotoDetail",
      { page: "ArticleDetail", id }
    )
  }

  // 触底加载下一页
  loadMore() {
    this.ctx.rnInstance.emitComponentEvent(
      this.descriptor.tag,
      "reachEnd",
      {
        currentIndex: this.currentIndex,
        currentTab: this.tabData[this.currentIndex]
      }
    )
  }

  // @Builder
  // tabBuilder(index: number, name: string) {
  //   Column() {
  //     Text(name)
  //       .fontSize(16)
  //       .fontWeight(500)
  //       .fontColor(this.currentIndex === index ? '#5763BD' : '#2E2E2E')
  //   }
  //   .width('100%')
  //   .layoutWeight(1)
  //   .justifyContent(FlexAlign.Center)
  // }

  // @Builder
  // listBuilder(index: number) {
  //   TabContent() {
  //     List({ scroller: this.scrollerForLists[index] }) {
  //         LazyForEach(this.listData[index], (item: ListItemProps) => {
  //           ListItem() {
  //             Column() {
  //                 Image('https://img.xssdcdn.com' + item.pic)
  //                   .width('100%')
  //                   .aspectRatio(350 / 205)
  //                   .backgroundColor('rgba(129,129,129,0.09)')
  //                   .borderRadius(8)
  //
  //                 Text(item.title)
  //                   .fontSize(15)
  //                   .fontWeight(500)
  //                   .fontColor('#404040')
  //                   .maxLines(1)
  //                   .textOverflow({ overflow: TextOverflow.Ellipsis })
  //                   .margin({ top: 13 })
  //
  //               Row() {
  //                 Text('\ue7c4')
  //                   .fontSize(16)
  //                   .fontColor('#ADADAD')
  //                   .fontFamily('iconfont')
  //                   .margin({ right: 5 })
  //                 Text(item.favcnt)
  //                   .fontSize(12)
  //                   .fontColor('#ADADAD')
  //                   .margin({ right: 10 })
  //
  //                 Text('\ue7cc')
  //                   .fontSize(16)
  //                   .fontColor('#ADADAD')
  //                   .fontFamily('iconfont')
  //                   .margin({ right: 5 })
  //                 Text(item.replycnt)
  //                   .fontSize(12)
  //                   .fontColor('#ADADAD')
  //                   .margin({ right: 10 })
  //               }
  //               .margin({ top: 6 })
  //             }
  //             .width('100%')
  //             .alignItems(HorizontalAlign.Start)
  //             .padding({ top: 0, right: 20, bottom: 25, left: 20 })
  //           }
  //           .width('100%')
  //         }, (item: ListItemProps) => item.id)
  //     }
  //     .width('100%')
  //     .height('100%')
  //     .padding({ top: this.listOffset[index] })
  //     .edgeEffect(EdgeEffect.None)
  //     .scrollBar(BarState.Off)
  //     .nestedScroll({
  //       scrollForward: NestedScrollMode.PARENT_FIRST,
  //       scrollBackward: NestedScrollMode.SELF_FIRST
  //     })
  //     .onReachEnd(() => this.loadMore())
  //   }
  //   .tabBar(null)
  // }

  build() {
    RNViewBase({ ctx: this.ctx, tag: this.tag }) {
      Scroll(this.scrollerForScroll) {
        Column() {
          Text("111111111111111111111111111")
        }
        .width('100%')
        .height(200)
        .border({ width: 1, color: '#000' })
        // Column()  {
        //   // 滚动容器的顶部区
        //   // Column() {
        //   //   // 轮播图
        //   //   Swiper() {
        //   //     ForEach(this.banner, (item: BannerProps, index: number) => {
        //   //       Column() {
        //   //         Text(item.title)
        //   //           .fontSize(19)
        //   //           .fontWeight('bold')
        //   //           .fontColor('#FFFFFF')
        //   //           .lineSpacing(LengthMetrics.px(1))
        //   //           .textOverflow({ overflow: TextOverflow.Ellipsis })
        //   //           .maxLines(1)
        //   //           .lineHeight(28)
        //   //           .textShadow({ radius: 8, color: '#595959' })
        //   //       }
        //   //       .alignItems(HorizontalAlign.Start)
        //   //       .margin({ left: 30, bottom: '10%' })
        //   //     }, (item: BannerProps) => item.id)
        //   //   }
        //   //   .loop(true)
        //   //   .autoPlay(true)
        //   //   .interval(3000)
        //   //   .indicator(
        //   //     Indicator.dot()
        //   //       .right(0)
        //   //       .itemWidth(20)
        //   //       .itemHeight(2)
        //   //       .selectedItemWidth(20)
        //   //       .selectedItemHeight(2)
        //   //       .color('rgba(255,255,255,0.3)')
        //   //       .selectedColor('#FFFFFF')
        //   //   )
        //   //   .indicatorInteractive(false)
        //   //   .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
        //   //     if (newValue.height && newValue.height > 0) {
        //   //       AppStorage.setOrCreate('homeSwiperHeight', newValue.height);
        //   //     }
        //   //   })
        //   // }
        //   // .width('100%')
        //   // .height(273)
        //   // .backgroundColor('#000')
        //   // .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
        //   //   if (newValue.height && newValue.height > 0) {
        //   //     AppStorage.setOrCreate('homeHeaderHeight', newValue.height);
        //   //   }
        //   // })
        //
        //   // 滚动容器的底部列表区
        //   // Stack({ alignContent: Alignment.Top }) {
        //   //   Row() {
        //   //     ForEach(this.tabData, (tabName: string, tabIndex: number) => {
        //   //       Column() {
        //   //         Text(tabName)
        //   //           .fontColor(this.currentIndex === tabIndex ? '#5763BD' : '#2E2E2E')
        //   //           .fontSize(16)
        //   //           .fontWeight(500)
        //   //       }
        //   //       .width('100%')
        //   //       .layoutWeight(1)
        //   //       .justifyContent(FlexAlign.Center)
        //   //       .onClick(() => this.tabController.changeIndex(tabIndex))
        //   //     }, (item: string) => item)
        //   //   }
        //   //   .width('100%')
        //   //   .height(72)
        //   //   .padding({ top: 30 })
        //   //   .zIndex(1)
        //   //   .backgroundColor('#FFFFFF')
        //   //
        //   //   Tabs({ controller: this.tabController }) {
        //   //     ForEach(this.tabData, (item: string, tabIndex: number) => {
        //   //       if (this.listData && this.listData[tabIndex]) {
        //   //         this.listBuilder(tabIndex)
        //   //       }
        //   //     }, (item: string) => item)
        //   //   }
        //   //   .margin({ top: 72 })
        //   //   .barHeight(0)
        //   //   .barWidth(0)
        //   //   .onAnimationStart((_index: number, targetIndex: number, _event: TabsAnimationEvent) => {
        //   //     this.currentIndex = targetIndex;
        //   //   })
        //   // }
        //   // .width('100%')
        //   // .height('100%')
        // }
      }
      .width('100%')
      .height(724)
      .backgroundColor('#000')
      .scrollBar(BarState.Off)
      .onScrollFrameBegin((offset: number) => {
        return { offsetRemain: offset }
      })
    }
  }
}