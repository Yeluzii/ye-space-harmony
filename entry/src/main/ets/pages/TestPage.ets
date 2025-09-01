@Component
export struct TestPage {
  build() {
    Column() {
      Text('测试页')
    }
  }
}

// 导航栏突出测试页，以下代码放到Layout中
// import { FriendPage } from './FriendPage';
// import { HomePage } from './HomePage';
// import { Mine } from './Mine';
// import { PostPage } from './PostPage';
// import { AppStorageV2, CommonModifier, Font } from '@kit.ArkUI';
// import { User } from '../module/user';
// import { TestPage } from './TestPage';
//
// interface TabClass {
//   title: string;
//   targetIndex: number;
//   selectedIcon: Resource;
//   unselectIcon: Resource;
// }
//
// @Builder
// export function LayoutBuilder() {
//   Layout();
// }
//
// @ComponentV2
// struct Layout {
//   private tabsController: TabsController = new TabsController();
//   @Local currentIndex: number = 0;
//   pathStack: NavPathStack = new NavPathStack();
//
//   @Builder
//   tabBarBuilder(title: string, targetIndex: number, selectedIcon: Resource, unselectIcon: Resource) {
//     Column({ space: 5 }) {
//       Image(this.currentIndex === targetIndex ? selectedIcon : unselectIcon)
//         .width(24)
//       Text(title)
//         .fontFamily('HarmonyHeiTi-Medium')
//         .fontSize(14)
//         .fontColor(this.currentIndex === targetIndex ? '#0A59F7' : '#63AAAA')
//         .textAlign(TextAlign.Center)
//         .fontWeight(500)
//     }
//     .width('100%')
//     .height('100%')
//     .justifyContent(FlexAlign.Center)
//     .alignItems(HorizontalAlign.Center)
//     .onClick(() => {
//       this.currentIndex = targetIndex;
//       this.tabsController.changeIndex(targetIndex)
//     })
//   }
//
//   // 测试标签专用凸起TabBar构建器
//   @Builder
//   testTabBarBuilder() {
//     Column({ space: 5 }) {
//       Image(this.currentIndex === 2 ? $r('app.media.test_selected') : $r('app.media.test'))
//         .width(50)
//       Text("测试")
//         .fontFamily('HarmonyHeiTi-Medium')
//         .fontSize(14)
//         .fontColor(this.currentIndex === 2 ? '#0A59F7' : '#63AAAA')
//         .textAlign(TextAlign.Center)
//         .fontWeight(500)
//     }
//     .justifyContent(FlexAlign.Center)
//     .alignItems(HorizontalAlign.Center)
//     // 核心代码1
//     .offset({ y: -20 })
//     .width('100%')
//     .height('100%')
//     .onClick(() => {
//       this.currentIndex = 2;
//       this.tabsController.changeIndex(2)
//     })
//   }
//
//   // 核心代码2
//   tabBarModifier: CommonModifier = new CommonModifier().clip(false);
//
//   build() {
//     NavDestination() {
//       // 核心代码3
//       Tabs({ barPosition: BarPosition.End, controller: this.tabsController, barModifier: this.tabBarModifier }) {
//         TabContent() {
//           PostPage()
//         }
//         .tabBar(this.tabBarBuilder('动态', 0, $r('app.media.post_blue_selected'), $r('app.media.post')))
//
//         TabContent() {
//           FriendPage()
//         }
//         .tabBar(this.tabBarBuilder('好友', 1, $r('app.media.friends_blue_selected'), $r('app.media.friends')))
//
//         TabContent() {
//           TestPage()
//         }
//         .tabBar(
//           this.testTabBarBuilder()
//         )
//
//         TabContent() {
//           HomePage()
//         }
//         .tabBar(this.tabBarBuilder('主页', 3, $r('app.media.home_blue_selected'), $r('app.media.home')))
//
//         TabContent() {
//           Mine()
//         }
//         .tabBar(this.tabBarBuilder('我的', 4, $r('app.media.mine_blue_selected'), $r('app.media.mine')))
//         .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
//       }
//       .divider({
//         strokeWidth: '2vp',
//         color: Color.Gray,
//       })
//       .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
//       .scrollable(false)
//       .vertical(false)
//     }
//     .onReady((context: NavDestinationContext) => {
//       this.pathStack = context.pathStack;
//     })
//   }
// }
