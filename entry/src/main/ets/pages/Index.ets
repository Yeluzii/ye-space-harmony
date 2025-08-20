import { AppStorageV2 } from '@kit.ArkUI'

// 持久化用户状态（退出应用下次还有）
PersistentStorage.persistProp('user', null)

@Entry
@Component
struct Index {
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!

  build() {
    Navigation(this.pathStack) {
    }.onAppear(() => {
      this.pathStack.pushPathByName('Start', null, false)
    })
    .hideNavBar(true)
  }
}