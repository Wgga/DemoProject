import { LengthMetrics } from '@kit.ArkUI';
import { Descriptor, RNOHContext, RNViewBase, ViewBaseProps } from '@rnoh/react-native-openharmony';

interface ListItemDataProps {
  id: number;
  name: string;
  up: string;
}

interface ListDataProps {
  items: ListItemDataProps[];
  noMore: boolean;
}

export const HOME_LIST_NAME: string = 'HomeList';

export interface HomeListProps extends ViewBaseProps {
  contentHeight: string;
  tabData: string[];
}

@Observed
class ListItemData {
  id: number;
  name: string;
  up: string;

  constructor(listItem: ListItemDataProps) {
    this.id = listItem.id;
    this.name = listItem.name;
    this.up = listItem.up;
  }
}

class ItemListData implements IDataSource {
  private dataArray: ListItemData[];
  private noMore: boolean;
  private listeners: DataChangeListener[] = [];

  constructor(dataArray: ListItemData[], noMore: boolean) {
    this.dataArray = dataArray;
    this.noMore = noMore;
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getList(): ListItemData[] {
    return this.dataArray;
  }

  public getData(index: number): ListItemData {
    return this.dataArray[index];
  }

  public getNoMore(): boolean {
    return this.noMore;
  }

  public getItemIndex(id: number): number {
    return this.dataArray.findIndex((data: ListItemData) => data.id === id);
  }

  public setData(dataArray: ListItemData[], noMore: boolean): void {
    this.dataArray = dataArray;
    this.noMore = noMore;
    this.notifyDataChange();
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  notifyDataChange(): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange([])
    })
  }
}

export type HomeListDescriptor = Descriptor<'HomeList', HomeListProps>;

@Component
struct ReplyItemView {
  @ObjectLink data: ListItemData;
  handleClick: (type: string, data: string) => void = () => {
  }; // 跳转方法

  setItemUp(type: number) {
    this.handleClick('postDiscussUp', JSON.stringify({ item: this.data, type }))
  }

  build() {
    Column() {
      Text(this.data.name)
        .fontSize(18)

      Text(this.data.up)
        .fontSize(15)

      Button('点赞').onClick(() => this.setItemUp(1))
    }
    .width('100%')
  }
}

@Component
export struct HomeList {
  ctx!: RNOHContext;
  tag: number = 0;
  private unregisterDescriptorChangesListener?: () => void = undefined;
  @State private descriptor: HomeListDescriptor = {} as HomeListDescriptor;
  @StorageProp('topRectHeight') topRectHeight: number = 0; // 顶部安全距离
  @State src: string = ''; // 和props里的src绑定
  @State contentHeight: string = ''; // 容器高度
  @State tabData: string[] = []; // tab数据
  @State discussListData: ItemListData = new ItemListData([], false); // 长评论列表数据
  private scrollerForScroll: Scroller = new Scroller() // 外层滚动实例

  aboutToAppear(): void {
    this.descriptor = this.ctx.descriptorRegistry.getDescriptor<HomeListDescriptor>(this.tag)

    this.unregisterDescriptorChangesListener =
      this.ctx.descriptorRegistry.subscribeToDescriptorChanges(this.tag, (newDescriptor) => {
        this.descriptor = (newDescriptor as HomeListDescriptor)
      })

    console.log('HomeList rawProps = ', JSON.stringify(this.descriptor.rawProps), this.tag)
    console.log('HomeList props = ', JSON.stringify(this.descriptor.props), this.tag)
    this.contentHeight = (this.descriptor.rawProps as HomeListProps).contentHeight
    this.tabData = (this.descriptor.rawProps as HomeListProps).tabData

    // 监听rn侧的事件消息
    this.ctx.componentCommandReceiver.registerCommandCallback(this.tag, (commandName: string, args: string[]) => {
      if (args.length == 0) {
        return;
      }
      if (commandName === "setListData") {
        const data: ListDataProps = JSON.parse(JSON.stringify(args[0]));
        const listData: ListItemData[] = data.items.map((item: ListItemDataProps) => new ListItemData(item));
        this.discussListData.setData(listData, data.noMore);
      } else if (commandName === "setItemUp") {
        const data: ListItemDataProps = JSON.parse(JSON.stringify(args[0]));
        const index: number = this.discussListData.getItemIndex(data.id);
        this.discussListData.getData(index).up = data.up;
      }
    })
  }

  aboutToDisappear(): void {
    this.unregisterDescriptorChangesListener?.()
  }

  // 处理页面点击事件
  handleClick(type: string, data: string) {
    this.ctx.rnInstance.emitComponentEvent(
      this.descriptor.tag,
      'click',
      { type, data }
    )
  }

  // 触底加载下一页
  loadMore(): void {
    this.ctx.rnInstance.emitComponentEvent(
      this.descriptor.tag,
      'reachEnd',
      {}
    )
  }

  build() {
    RNViewBase({ ctx: this.ctx, tag: this.tag }) {
      Column() {
        if (this.discussListData.totalCount() > 0) {
          List() {
            LazyForEach(this.discussListData, (item: ListItemData, index: number) => {
              ListItem() {
                Column() {
                  ReplyItemView({
                    data: item,
                    handleClick: (type: string, data: string) => {
                      this.handleClick(type, data);
                    }
                  })
                }
                .width('100%')
              }
              .width('100%')
              .padding({
                top: 30,
                right: 20,
                bottom: 30,
                left: 20
              })
              .border({ width: { bottom: 1 }, color: Color.Pink })
            }, (item: ListItemData, index: number) => `${JSON.stringify(item)}_${index}`)

            ListItem() {
              if (!this.discussListData.getNoMore()) {
                LoadingProgress()
                  .width(32)
                  .height(32)
              } else {
                Text('没有更多内容了')
                  .fontSize(13)
                  .fontColor('#999999')
              }
            }
            .width('100%')
            .height(60)
            .margin({ bottom: 100 })
          }
          .width('100%')
          .height('100%')
          .edgeEffect(EdgeEffect.None)
          .scrollBar(BarState.Off)
          .nestedScroll({
            scrollForward: NestedScrollMode.PARENT_FIRST,
            scrollBackward: NestedScrollMode.SELF_FIRST
          })
          .onReachEnd(() => this.loadMore())
        }
      }
      .width('100%')
      .height(this.contentHeight)
    }
  }
}