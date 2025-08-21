import { User } from "../module/user";
import { AppStorageV2 } from "@kit.ArkUI";
import { logoutApi } from "../network/api/login"

@Builder
export function MineBuilder() {
  Mine()
}

@Component
export struct Mine {
  @StorageLink('user')
  user: User | undefined = AppStorage.get('user')
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!

  async logout() {
    try {
      await logoutApi()
    } catch (e) {
      console.log(e)
    } finally {
      AppStorage.setOrCreate('user', null)
      this.pathStack.pushPathByName("Login", null, true);
    }
  }

  build() {
    Column({ space: 5 }) {
      Column() {
        Stack({ alignContent: Alignment.Bottom }) {
          Image(this.user?.bgImg ?? $r('app.media.user_background'))
            .objectFit(ImageFit.Cover)
            .height('100%')
            .width('100%')
            .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])

          Image(this.user?.avatar ? this.user.avatar : $r('app.media.avatar_null_blue'))
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
        if (!this.user) {
          Text('未登录')
          Text("----")
            .fontSize(12)
            .fontWeight(400)
            .fontFamily('HarmonyHeiTi-Medium')
            .textAlign(TextAlign.Center)
            .lineHeight(14)
          Button("登录")
            .onClick(() => {
              this.pathStack.pushPathByName("Login", null, true);
            })
        } else {
          Text(this.user.nickname)
            .fontSize(24)
            .fontWeight(600)
          Text(this.user.slogan)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .ellipsisMode(EllipsisMode.END)
            .fontSize(12)
            .fontWeight(400)
            .fontFamily('HarmonyHeiTi-Medium')
            .textAlign(TextAlign.Center)
            .lineHeight(14)
          Button("退出登录")
            .onClick(() => {
              this.logout()
            })
        }
      }
      .margin({ top: '60vp' })
      .width('80%')
      .layoutWeight(1)
    }
    .width('100%')
  }
}
