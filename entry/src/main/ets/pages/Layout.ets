import { FriendPage } from './FriendPage';
import { HomePage } from './HomePage';
import { Mine } from './Mine';
import { PostPage } from './PostPage';
import { AppStorageV2, Font } from '@kit.ArkUI';
import { User } from '../module/user';

@Builder
export function LayoutBuilder() {
  Layout();
}

@Component
struct Layout {
  private tabsController: TabsController = new TabsController();
  @State currentIndex: number = 0;
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack',() => new NavPathStack())!
  font: Font = new Font();
  @StorageLink('user')
  user: User | undefined = AppStorage.get('user')

  aboutToAppear(): void {
    // 注册字体
    this.font.registerFont({
      familyName: '阿里汉仪智能黑体',
      familySrc: $rawfile('fonts/阿里汉仪智能黑体.ttf')
    })
    if(!this.user){
      this.pathStack.pushPathByName("Login", null, true);
    }
  }

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

        TabContent() {
          HomePage()
        }
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .backgroundColor('#F6F6F6')
        .tabBar(this.tabBarBuilder('主页', 0, $r('app.media.home_blue_selected'), $r('app.media.home')))

        TabContent() {
          PostPage()
        }
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .backgroundColor('#F6F6F6')
        .tabBar(this.tabBarBuilder('动态', 1, $r('app.media.post_blue_selected'), $r('app.media.post')))

        TabContent() {
          FriendPage()
        }
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .backgroundColor('#F6F6F6')
        .tabBar(this.tabBarBuilder('好友', 2, $r('app.media.friends_blue_selected'), $r('app.media.friends')))

        TabContent() {
          Mine()
        }
        .backgroundColor('#F6F6F6')
        .tabBar(this.tabBarBuilder('我的', 3, $r('app.media.mine_blue_selected'), $r('app.media.mine')))
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
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
