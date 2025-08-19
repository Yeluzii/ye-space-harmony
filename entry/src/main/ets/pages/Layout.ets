import { FriendPage } from './FriendPage';
import { HomePage } from './HomePage';
import { Mine } from './Mine';
import { PostPage } from './PostPage';
import { AppStorageV2, Font } from '@kit.ArkUI';
import { User } from '../module/user';

interface TabClass {
  title: string;
  targetIndex: number;
  selectedIcon: Resource;
  unselectIcon: Resource;
}

@Builder
export function LayoutBuilder() {
  Layout();
}

@Component
struct Layout {
  private tabsController: TabsController = new TabsController();
  @State currentIndex: number = 0;
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!
  font: Font = new Font();

  // @StorageLink('user')
  // user: User | undefined = AppStorage.get('user')

  aboutToAppear(): void {
    // 注册字体
    this.font.registerFont({
      familyName: '阿里汉仪智能黑体',
      familySrc: $rawfile('fonts/阿里汉仪智能黑体.ttf')
    })
    // if(!this.user){
    //   this.pathStack.pushPathByName("Login", null, true);
    // }
  }

  tabsData: TabClass[] = [
    {
      title: '主页',
      targetIndex: 0,
      selectedIcon: $r('app.media.home_blue_selected'),
      unselectIcon: $r('app.media.home'),
    },
    {
      title: '动态',
      targetIndex: 1,
      selectedIcon: $r('app.media.post_blue_selected'),
      unselectIcon: $r('app.media.post'),
    },
    {
      title: '好友',
      targetIndex: 2,
      selectedIcon: $r('app.media.friends_blue_selected'),
      unselectIcon: $r('app.media.friends'),
    },
    {
      title: '我的',
      targetIndex: 3,
      selectedIcon: $r('app.media.mine_blue_selected'),
      unselectIcon: $r('app.media.mine'),
    }
  ]

  @Builder
  tabBarBuilder(title: string, targetIndex: number, selectedIcon: Resource, unselectIcon: Resource) {
    Column({ space: 5 }) {
      Image(this.currentIndex === targetIndex ? selectedIcon : unselectIcon)
        .width(24)
      Text(title)
        .fontFamily('阿里汉仪智能黑体')
        .fontSize(14)
        .fontColor(this.currentIndex === targetIndex ? '#0A59F7' : '#63AAAA')
        .textAlign(TextAlign.Center)
        .fontWeight(500)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex;
      this.tabsController.changeIndex(targetIndex)
    })
  }

  build() {
    NavDestination() {
      Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
        ForEach(this.tabsData, (item: TabClass) => {
          TabContent() {
            if (item.targetIndex === 0) {
              HomePage()
            } else if (item.targetIndex === 1) {
              PostPage()
            } else if (item.targetIndex === 2) {
              FriendPage()
            } else if (item.targetIndex === 3) {
              Mine()
            }
          }
          .tabBar(this.tabBarBuilder(item.title, item.targetIndex, item.selectedIcon, item.unselectIcon))
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
          .backgroundColor('#F6F6F6')
        })
      }
      .divider({
        strokeWidth: '2vp',
        color: Color.Gray,
      })
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .scrollable(false)
      .vertical(false)
    }
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}
