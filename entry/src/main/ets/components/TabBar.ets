/**
 * @file: TabBar.ets
 * @author: Yeluzii
 * @date: 2025/09/15
 */
import { Font } from "@kit.ArkUI"

export interface TabItem {
  title: string
  icon: Resource
  selectedIcon: Resource
}

@Component
export struct TabBar {
  @Prop selectedIndex: number = 0
  tabItems: TabItem[] = []
  onTabClick?: (index: number) => void
  font: Font = new Font()

  aboutToAppear(): void {
    // 注册字体
    this.font.registerFont({
      familyName: '阿里汉仪智能黑体',
      familySrc: $rawfile('fonts/阿里汉仪智能黑体.ttf')
    })
  }

  build() {
    Row() {
      ForEach(this.tabItems, (item: TabItem, index: number) => {
        Column() {
          Image(this.selectedIndex === index ? item.selectedIcon : item.icon)
            .width(24)
            .height(24)

          Text(item.title)
            .fontFamily('阿里汉仪智能黑体')
            .fontWeight(500)
            .fontSize(14)
            .fontColor(this.selectedIndex === index ? '#0A59F7' : '#63AAAA')
            .margin({ top: 4 })
            .fontWeight(this.selectedIndex === index ? FontWeight.Medium : FontWeight.Normal)
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .padding({ top: 8, bottom: 8 })
        .onClick(() => {
          this.onTabClick?.(index)
        })
      })
    }
    .width('100%')
    .height(50)
    .backgroundColor('#F6F6F6')
    .border({
      width: { top: 0.5 },
      color: '#E5E5EA'
    })
  }
}