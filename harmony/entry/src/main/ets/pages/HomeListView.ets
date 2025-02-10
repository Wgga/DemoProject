import { display, LengthMetrics } from "@kit.ArkUI";
import { Descriptor, RNOHContext, RNViewBase, ViewBaseProps } from "@rnoh/react-native-openharmony";

interface BannerProps {
  id: string;
  title: string;
}

interface ListItemProps {
  id: string;
  title: string;
}

export interface HomeListViewProps extends ViewBaseProps {
  src: string,
  contentHeight: string,
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

  @State src: string = "" // 和props里的src绑定
  @State contentHeight: string = ""
  @State tabData: string[] = [] // tab数据
  @State banner: BannerProps[] = []
  @State listData: ArticleListData[] = [] // 列表数据
  @State listOffset: number[] = [0, 0, 0, 0] // 列表偏移量数据
  @State currentIndex: number = 0 // 当前tab索引
  @State isRefreshing: boolean = false // 是否刷新中
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
    for (let i = 0; i < 5; i++) {
      this.banner.push({
        id: i.toString(),
        title: (i + 1).toString(),
      })
    }
    const ListArr: ListItemProps[] = [];
    for (let i = 0; i < 120; i++) {
      ListArr.push({
        id: i.toString(),
        title: (i + 1).toString(),
      })
    }
    this.tabData.forEach((_,i: number) => {
      this.listData.push(new ArticleListData(ListArr))
    })

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

  @Builder
  listBuilder(tabName: string, tabIndex: number) {
    TabContent() {
      List({ scroller: this.scrollerForLists[tabIndex] }) {
          LazyForEach(this.listData[tabIndex], (item: ListItemProps) => {
            ListItem() {
              Column() {
                Text(tabName + item.title)
                  .fontSize(15)
                  .fontWeight(500)
                  .fontColor('#404040')
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .margin({ top: 13 })
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)
              .padding({ top: 0, right: 20, bottom: 25, left: 20 })
              .border({ width: { top: 1 }, color: '#000' })
            }
            .width('100%')
          }, (item: ListItemProps) => item.id)
      }
      .width('100%')
      .height('100%')
      .padding({ top: this.listOffset[tabIndex] })
      .edgeEffect(EdgeEffect.None)
      .scrollBar(BarState.Off)
      .nestedScroll({
        scrollForward: NestedScrollMode.PARENT_FIRST,
        scrollBackward: NestedScrollMode.SELF_FIRST
      })
      .onReachEnd(() => this.loadMore())
    }
    .tabBar(null)
  }

  build() {
    RNViewBase({ ctx: this.ctx, tag: this.tag }) {
      Refresh({ refreshing: $$this.isRefreshing }) {
        Scroll(this.scrollerForScroll) {
          Column()  {
            // 滚动容器的顶部区
            Column() {
              // 轮播图
              Swiper() {
                ForEach(this.banner, (item: BannerProps, index: number) => {
                  Column() {
                    Text(item.title)
                      .fontSize(19)
                      .fontWeight('bold')
                      .fontColor('#FFFFFF')
                      .lineSpacing(LengthMetrics.px(1))
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .maxLines(1)
                      .lineHeight(28)
                      .textShadow({ radius: 8, color: '#595959' })
                  }
                  .width('100%')
                  .height(273)
                  .justifyContent(FlexAlign.Center)
                  .alignItems(HorizontalAlign.Center)
                  .backgroundColor('rgb(230, 183, 205)')
                }, (item: BannerProps) => item.id)
              }
              .loop(true)
              .autoPlay(true)
              .interval(3000)
              .indicator(
                Indicator.dot()
                  .right(0)
                  .itemWidth(20)
                  .itemHeight(2)
                  .selectedItemWidth(20)
                  .selectedItemHeight(2)
                  .color('rgba(255,255,255,0.3)')
                  .selectedColor('#FFFFFF')
              )
              .indicatorInteractive(false)
            }
            .width('100%')

            // 滚动容器的底部列表区
            Stack({ alignContent: Alignment.Top }) {
              Row() {
                ForEach(this.tabData, (tabName: string, tabIndex: number) => {
                  Column() {
                    Text(tabName)
                      .fontColor(this.currentIndex === tabIndex ? '#5763BD' : '#2E2E2E')
                      .fontSize(16)
                      .fontWeight(500)
                  }
                  .width('100%')
                  .layoutWeight(1)
                  .justifyContent(FlexAlign.Center)
                  .onClick(() => this.tabController.changeIndex(tabIndex))
                }, (item: string) => item)
              }
              .width('100%')
              .height(72)
              .padding({ top: 30 })
              .zIndex(1)
              .backgroundColor('#FFFFFF')

              Tabs({ controller: this.tabController }) {
                ForEach(this.tabData, (tabName: string, tabIndex: number) => {
                  if (this.listData && this.listData[tabIndex]) {
                    this.listBuilder(tabName, tabIndex)
                  }
                }, (item: string) => item)
              }
              .margin({ top: 72 })
              .barHeight(0)
              .barWidth(0)
              .onAnimationStart((_index: number, targetIndex: number, _event: TabsAnimationEvent) => {
                this.currentIndex = targetIndex;
              })
            }
            .width('100%')
            .height('100%')
          }
        }
        .width('100%')
        .height('100%')
        .scrollBar(BarState.Off)
        .onScrollFrameBegin((offset: number) => {
          return { offsetRemain: offset }
        })
      }
      .width('100%')
      .height(this.contentHeight)
      .onStateChange((state: RefreshStatus)=> {
        console.log("HomeListView state = ", state);
      })
      .onRefreshing(() => {
        this.isRefreshing = true
        setTimeout(() => this.isRefreshing = false, 2000)
      })
    }
  }
}