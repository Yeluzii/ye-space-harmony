import { AppStorageV2 } from "@kit.ArkUI"
import { PostParams } from "../module/postParams"

@Builder
export function PostDetailBuilder() {
  PostDetail()
}

@Component
export struct PostDetail {
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!
  pathInfo: NavPathInfo = AppStorageV2.connect(NavPathInfo, 'postPathInfo')!
  @State
  title: string = ''

  aboutToAppear(): void {
    if (this.pathInfo.param) {
      const params = this.pathInfo.param as PostParams
      this.title = params.title
    }
  }

  build() {
    NavDestination() {
      Column() {
        Text(this.title)
      }
    }
    .title("动态详情")
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}