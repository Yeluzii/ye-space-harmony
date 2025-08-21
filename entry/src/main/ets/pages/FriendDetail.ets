import { AppStorageV2 } from "@kit.ArkUI"
import { Friend } from "../network/interface/friend"

@Builder
export function FriendDetailBuilder() {
  FriendDetail()
}

@Component
export struct FriendDetail {
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!
  friendPathInfo: NavPathInfo = AppStorageV2.connect(NavPathInfo, 'friendPathInfo')!
  @State
  selectedFriend: Friend.FriendInfo = this.friendPathInfo.param as Friend.FriendInfo

  // aboutToAppear(): void {
  //   if (this.friendPathInfo.param) {
  //     this.selectedFriend = this.friendPathInfo.param as Friend.FriendInfo
  //     console.log("===================", this.selectedFriend);
  //   }
  // }

  build() {
    NavDestination() {
      Column() {
        Column({ space: 5 }) {

          Stack({ alignContent: Alignment.Bottom }) {
            Stack({ alignContent: Alignment.TopStart }) {
              Image($r('app.media.user_background'))
                .objectFit(ImageFit.Cover)
                .height('100%')
                .width('100%')
                .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])

              Image($r('app.media.arrow_left'))
                .stateStyles({
                  pressed: {
                    .backgroundColor(Color.Black)
                    .opacity(0.8)
                  }
                })
                .backgroundColor('#F3F3F3')
                .padding(5)
                .margin({ left: '15vp' })
                .width('30vp')
                .height('30vp')
                .clip(true)
                .borderRadius('50%')
                .onClick(() => {
                  this.pathStack.pop()
                })
            }

            Image(this.selectedFriend?.avatar || $r('app.media.avatar_null_blue'))
              .clip(true)
              .objectFit(ImageFit.Cover)
              .borderRadius('50%')
              .backgroundColor(Color.Gray)
              .width('120vp')
              .height('120vp')
              .margin({ bottom: '-60vp' })
              .border({ width: '2vp', color: Color.White })
          }
          .width('100%')
          .height('200vp')
        }
        .height('200vp + 60vp')
        .width('100%')

        Column({ space: 5 }) {
          Text(this.selectedFriend.note ? this.selectedFriend.note + " (" + this.selectedFriend.nickname + ")" : this.selectedFriend.nickname)
            .fontSize(24)
            .fontWeight(600)
          Text(this.selectedFriend.slogan ? this.selectedFriend.slogan : "----")
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .ellipsisMode(EllipsisMode.END)
            .fontSize(12)
            .fontWeight(400)
            .fontFamily('HarmonyHeiTi-Medium')
            .textAlign(TextAlign.Center)
            .lineHeight(14)
        }
        .margin({
          top: '60vp'
        })
        .width('80%')
        .layoutWeight(1)
      }
      .expandSafeArea([SafeAreaType.SYSTEM], [, SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
      .width('100%')
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [, SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}