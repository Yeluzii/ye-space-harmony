import { User } from "../module/user"
import { Font } from "@kit.ArkUI"

@Preview
@Component
export struct HomePage {
  @State
  date: Date = new Date()
  @State time: string = ''
  private timer: number = -1
  @StorageLink('user')
  user: User | undefined = AppStorage.get('user')
  font: Font = new Font()

  // 组件生命周期：组件出现时启动定时器
  aboutToAppear() {
    // 初始化时间
    this.updateTime()
    // 启动定时器，每秒更新一次时间
    this.timer = setInterval(() => {
      this.updateTime()
    }, 1000)
    // 注册字体
    this.font.registerFont({
      familyName: 'TanukiMagic',
      familySrc: $rawfile('fonts/TanukiMagic麦克笔手绘.ttf')
    })
  }

  // 组件生命周期：组件消失时清除定时器
  aboutToDisappear() {
    if (this.timer !== -1) {
      clearInterval(this.timer)
      this.timer = -1
    }
  }

  // 更新时间的方法
  private updateTime() {
    this.date = new Date()
    // 格式化时间，只保留时分秒部分
    this.time = this.date.toTimeString().split(' ')[0]
  }

  build() {
    Column({ space: 5 }) {
      Column({ space: 10 }) {
        Text("现在是")
          .fontSize(50)
          .width('100%')
        Text(this.date.getFullYear() + ' 年')
          .fontSize(24)
          .width('100%')
        Text(this.date.getMonth()+1 + ' 月')
          .fontSize(30)
          .width('100%')
        Text(this.date.getDate() + ' 日')
          .fontSize(35)
          .width('100%')
        Text("星期" + ['日', '一', '二', '三', '四', '五', '六'][this.date.getDay()])
          .fontSize(40)
          .width('100%')
        Text(this.time)
          .fontFamily('TanukiMagic')
          .fontSize(50)
        Text(this.user?.slogan ? "💕" + this.user?.slogan : "💕💕💕")
          .fontFamily('TanukiMagic,HarmonyHeiTi-Medium')
          .fontSize(16)
          .maxLines(1)
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })
          .ellipsisMode(EllipsisMode.END)
      }
      .padding("20vp")
      .border({
        radius: 16,
        width: 1,
        color: Color.Black,
      })
      .shadow({
        radius: 5,
        offsetX: 5,
        offsetY: 5,
        color: Color.Gray
      })
      .margin({
        top: '5vp'
      })
      .width('90%')
    }
    .width('100%')
    .height('100%')
  }
}