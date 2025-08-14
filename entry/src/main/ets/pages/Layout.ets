import { FriendPage } from './FriendPage';
import { HomePage } from './HomePage';
import { Mine } from './Mine';
import { PostPage } from './PostPage';

@Builder
export function LayoutBuilder() {
  Layout();
}

@ComponentV2
struct Layout {
  private tabsController: TabsController = new TabsController();
  @Local currentIndex: number = 0;
  pathStack: NavPathStack = new NavPathStack();

  @Builder
  tabBarBuilder(title: string, targetIndex: number, selectedIcon: Resource, unselectIcon: Resource) {
    Column({ space: 5 }) {
      Image(this.currentIndex === targetIndex ? selectedIcon : unselectIcon)
        .width(24)
      Text(title)
        .fontFamily('HarmonyHeiTi-Medium')
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
        .tabBar(this.tabBarBuilder('主页', 0, $r('app.media.home_blue_selected'), $r('app.media.home')))

        TabContent() {
          FriendPage()
        }
        .tabBar(this.tabBarBuilder('好友', 1, $r('app.media.friends_blue_selected'), $r('app.media.friends')))

        TabContent() {
          PostPage()
        }
        .tabBar(this.tabBarBuilder('动态', 2, $r('app.media.post_blue_selected'), $r('app.media.post')))

        TabContent() {
          Mine()
        }
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
