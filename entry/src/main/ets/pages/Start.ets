// 跳转页面入口函数
@Builder
export function StartBuilder() {
  Start();
}

@Component
struct Start {
  // 控制跳转的对象
  pathStack: NavPathStack = new NavPathStack();
  private timerId: number = 0;
  private intervalId: number = 0;
  @State countdown: number = 3; // 倒计时秒数

  // 生命周期,组件即将显示时，build() 函数执行前
  aboutToAppear(): void {
    // 设置倒计时
    this.intervalId = setInterval(() => {
      if (this.countdown > 0) {
        this.countdown -= 1;
      } else {
        clearInterval(this.intervalId);
      }
    }, 1000);

    // 设置自动跳转
    this.timerId = setTimeout(() => {
      clearInterval(this.intervalId);
      this.pathStack.replacePathByName("Layout", null, false);
    }, this.countdown * 1000);
  }

  // 生命周期,组件即将消失时
  aboutToDisappear(): void {
    clearTimeout(this.timerId);
    clearInterval(this.intervalId);
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.TopEnd }) {
        Image($r('app.media.start'))
          .width('100%')
          .height('100%')
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

        Button('跳过(' + this.countdown + 's)')
          .backgroundColor(Color.Grey)
          .margin(15)
          .onClick(() => {
            clearTimeout(this.timerId);
            clearInterval(this.intervalId);
            this.pathStack.replacePathByName("Layout", null, false);
          })
      }
    }
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}