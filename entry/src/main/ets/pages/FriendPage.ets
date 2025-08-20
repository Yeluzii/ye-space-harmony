import { Friend } from '../network/interface/friend';
import { getFriendCategoriesApi, getFriendListApi } from '../network/api/friend';
import { AppStorageV2, PromptAction } from '@kit.ArkUI';
import { User } from '../module/user';

@Component
export struct FriendPage {
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!
  private tabsController: TabsController = new TabsController();
  toast: PromptAction = new PromptAction()
  @StorageLink('user')
  user: User | undefined = AppStorage.get('user')
  @State
  categoryList: Friend.ResFriendCategories[] = []
  getCategories = async () => {
    try {
      if (this.user?.accessToken) {
        const res = await getFriendCategoriesApi()
        this.categoryList = res.data
      } else {
        this.toast.showToast({
          message: '请先登录',
          duration: 2000,
          alignment: Alignment.Top
        })
      }
    } catch (e) {
      this.toast.showToast({
        message: '获取好友分组列表失败',
        duration: 2000,
      })
      console.log(e)
    }
  }
  @State
  reqFriendListParams: Friend.ReqFriendList = {
    page: 1,
    limit: 20,
    keywords: '',
    categoryId: 0
  }
  @State
  friendList: Friend.FriendInfo[] = []
  getAllFriends = async () => {
    try {
      if (this.user?.accessToken) {
        const res = await getFriendListApi({
          page: this.reqFriendListParams.page,
          limit: this.reqFriendListParams.limit,
          keywords: this.reqFriendListParams.keywords,
        })
        this.friendList = res.data.list
      }
    } catch (e) {
      this.toast.showToast({
        message: '获取好友列表失败',
        duration: 2000,
        alignment: Alignment.Top
      })
    }
  }
  getFriendList = async () => {
    try {
      if (this.user?.accessToken) {
        const res = await getFriendListApi(this.reqFriendListParams)
        this.friendList = res.data.list
      }
    } catch (e) {
      this.toast.showToast({
        message: '获取好友列表失败',
        duration: 2000,
        alignment: Alignment.Top
      })
    }
  }

  async aboutToAppear(): Promise<void> {
    await this.getCategories()
  }

  @Builder
  friendListBuilder() {
    Column() {
      List({ space: 20 }) {
        ForEach(this.friendList, (item: Friend.FriendInfo) => {
          ListItem() {
            Row({ space: 5 }) {
              Image(item.avatar)
                .clip(true)
                .borderRadius('20%')
                .width(40)
                .height(40)
                .fillColor('#817D83')
              Column({ space: 5 }) {
                Text(item.note || item.nickname)
                  .fontColor('#333')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .textAlign(TextAlign.Start)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .ellipsisMode(EllipsisMode.END)
                Text(item.slogan)
                  .fontColor('#999')
                  .fontSize(12)
                  .textAlign(TextAlign.Start)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .ellipsisMode(EllipsisMode.END)
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
          }
        })
      }
      .divider({
        strokeWidth: 1,
      })
    }
    .width('100%')
    .height('100%')
  }

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
        Image($r('app.media.ic_code'))
          .width(20)
          .fillColor('#817D83')
      }
      .height('40vp')
      .backgroundColor('#E9E9E9')
      .width('100%')
      .border({ radius: 20 })
      .padding({ left: 8, right: 8 })

      Tabs({ barPosition: BarPosition.Start, controller: this.tabsController }) {
        TabContent() {
          this.friendListBuilder()
        }
        .onVisibleAreaChange([0, 1], (isExpanding, currentRatio) => {
          if (isExpanding && currentRatio > 0) {
            // 内容出现，执行获取全部好友列表逻辑
            this.getAllFriends()
          } else if (!isExpanding && currentRatio == 0) {
            // 内容消失的相关逻辑
          }
        })
        .tabBar(SubTabBarStyle.of('全部好友'))

        ForEach(this.categoryList, (item: Friend.ResFriendCategories) => {
          TabContent() {
            this.friendListBuilder()
          }
          .onVisibleAreaChange([0, 1], (isExpanding, currentRatio) => {
            if (isExpanding && currentRatio > 0) {
              this.reqFriendListParams.categoryId = item.pkId
              // 内容出现，执行获取好友列表逻辑
              this.getFriendList()
            } else if (!isExpanding && currentRatio == 0) {
              // 内容消失的相关逻辑
            }
          })
          .tabBar(SubTabBarStyle.of(item.name))
        })
      }
      .margin({
        // 给出底部导航栏的位置，不然 好友列表最后一位 会被底部导航栏覆盖
        bottom: '45vp'
      })
      // 不用 onChange ，不然 UI 有延迟
      // .onChange((index: number) => {
      //   // if (index === 0) {
      //   //   this.getAllFriends()
      //   // } else
      //     if (index !== 0) {
      //     // 注意：categoryList 的索引需要减 1，因为第一个标签是"全部好友"
      //     const categoryIndex = index - 1;
      //     if (categoryIndex < this.categoryList.length) {
      //       this.reqFriendListParams.categoryId = this.categoryList[categoryIndex].pkId;
      //     }
      //     this.getFriendList();
      //   }
      // })
      .scrollable(true)
      .vertical(false)
      .barMode(BarMode.Scrollable)
    }
    .onVisibleAreaChange([0, 1], (isExpanding, currentRatio) => {
      if (isExpanding && currentRatio > 0) {
        // 内容出现，执行获取好友分组列表逻辑
        this.getCategories()
      } else if (!isExpanding && currentRatio == 0) {
        // 内容消失的相关逻辑
      }
    })
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