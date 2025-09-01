import { AppStorageV2 } from "@kit.ArkUI"
import { PostParams } from "../module/postParams"
import { Post } from "../network/interface/post"

@Builder
export function PostDetailBuilder() {
  PostDetail()
}

@Component
export struct PostDetail {
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!
  pathInfo: NavPathInfo = AppStorageV2.connect(NavPathInfo, 'postPathInfo')!
  @State
  post: Post.FriendsPost = this.pathInfo.param as Post.FriendsPost

  build() {
    NavDestination() {
      Column() {
        Text(this.post.content)
      }
    }
    .title("动态详情")
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}