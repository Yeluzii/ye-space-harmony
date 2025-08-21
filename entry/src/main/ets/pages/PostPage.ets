import { AppStorageV2 } from "@kit.ArkUI"
import { PostParams } from "../module/postParams"

@Component
export struct PostPage {
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!
  params: PostParams = {
    postId: 1,
    title: "二级页怎么弄？"
  }
  pathInfo: NavPathInfo = AppStorageV2.connect(NavPathInfo,'postPathInfo', () => new NavPathInfo("PostDetail",this.params))!

  build() {
    Column() {
      Text('PostPage')
      Button("二级页")
        .onClick(() => {
          this.pathStack.pushPath(this.pathInfo, true)
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