import { AppStorageV2 } from "@kit.ArkUI"

@Component
export struct PostPage {
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!

  build() {
    Column() {
      Text('PostPage')
      Button("二级页")
        .onClick(() => {
          this.pathStack.pushPathByName("PostDetail", null, true)
        })
    }
    .width('100%')
    .height('100%')
    .padding({
      left: 10,
      right: 10,
      top: 5,
      bottom: 5
    })
  }
}