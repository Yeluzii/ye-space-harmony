import { Friend } from "../network/interface/friend";
import { getFriendCategoriesApi } from "../network/api/friend"
import { AppStorageV2, PromptAction } from "@kit.ArkUI"
import { User } from "../module/user";

@Component
export struct FriendPage {
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!
  private tabsController: TabsController = new TabsController();
  toast: PromptAction = new PromptAction()
  @State
  categoryList: Friend.ResFriendCategories[] = []
  getCategories = async () => {
    try {
      const res = await getFriendCategoriesApi()
      this.categoryList = res.data
      console.log('====================好友分组列表:', res.data)
    } catch (e) {
      this.toast.showToast({
        message: '获取好友分组列表失败',
        duration: 2000,
      })
      console.log(e)
    }
  }

  aboutToAppear(): void {
    this.getCategories()
  }

  @StorageLink('user')
  user: User | undefined = AppStorage.get('user')

  build() {
    Column({ space: 5 }) {
      // 搜索区域
      Row() {
        Image($r('app.media.ic_search'))
          .width(22)
          .fillColor('#817D83')
        TextInput({ placeholder: '搜索好友...' })
          .backgroundColor(Color.Transparent)
          .placeholderColor('#817D83')
          .padding({ left: 5 })
          // 除去别的宽度，剩余的给 TextInput
          .layoutWeight(1)
          .fontColor('#999')
        // Image($r('app.media.ic_code'))
        //   .width(20)
        //   .fillColor('#817D83')
      }
      .backgroundColor('#E9E9E9')
      .width('100%')
      .border({ radius: 20 })
      .padding({ left: 8, right: 8 })

      Tabs({ barPosition: BarPosition.Start, controller: this.tabsController }) {
        TabContent() {
          Text('Tab1')
        }
        .tabBar(SubTabBarStyle.of('全部好友'))

        ForEach(this.categoryList, (item: Friend.ResFriendCategories) => {
          TabContent() {
            Text("分组id：" + item.pkId)
          }
          .tabBar(SubTabBarStyle.of(item.name))
        }, (item: Friend.ResFriendCategories) => item.pkId.toString())
      }
      .scrollable(true)
      .vertical(false)
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