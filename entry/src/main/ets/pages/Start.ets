// 跳转页面入口函数
@Builder
export function StartBuilder() {
  Start();
}

@Component
struct Start {
  // 控制跳转的对象
  pathStack: NavPathStack = new NavPathStack();

  // 过 3 秒中自动跳转到 Layout -> Start 页面打开计时 3秒后跳转
  // 生命周期,组件即将显示时，build() 函数执行前
  aboutToAppear(): void {
    setTimeout(() => {
      this.pathStack.replacePathByName("Layout", null, false);
    }, 2000);
  }

  build() {
    NavDestination() {
      // Button('点击跳到布局页')
      //   .onClick(() => {
      //     this.pathStack.pushPathByName("Layout", null, false);
      //   })

      // 层叠容器组件 调整内容对齐方式
      Stack({ alignContent: Alignment.TopEnd }) {
        Image($r('app.media.start'))
          .width('100%')
          .height('100%')
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        Button('跳过')
          .backgroundColor(Color.Grey)
          .margin(15)
          .onClick(() => {
            // 不支持返回的用 replace
            this.pathStack.replacePathByName("Layout", null, false);
          })
      }
    }
    // .title('广告页')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}