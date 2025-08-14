import { AppStorageV2 } from "@kit.ArkUI"

@Builder
export function PostDetailBuilder() {
  PostDetail()
}

@Component
export struct PostDetail {
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!

  build() {
    NavDestination() {

      Column() {
        Text('PostDetail')
      }
    }
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}