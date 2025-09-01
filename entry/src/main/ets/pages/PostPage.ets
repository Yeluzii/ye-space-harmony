import { AppStorageV2, PromptAction } from "@kit.ArkUI"
import { PostParams } from "../module/postParams"
import { Post } from "../network/interface/post"
import { getAllFriendsPostApi } from "../network/api/post"
import { User } from "../module/user"

@Component
export struct PostPage {
  toast: PromptAction = new PromptAction()
  @StorageLink('user')
  user: User | undefined = AppStorage.get('user')
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!
  params: PostParams = {
    postId: 1,
    title: "二级页怎么弄？"
  }
  pathInfo: NavPathInfo =
    AppStorageV2.connect(NavPathInfo, 'postPathInfo', () => new NavPathInfo("PostDetail", this.params))!
  @State
  reqFriendPostsParams: Post.ReqAllFriendsPostParams = {
    page: 1,
    limit: 20,
    keywords: '',
  }
  @State
  posts: Post.FriendsPost[] = []
  getAllFriendsPosts = async () => {
    try {
      if (this.user?.accessToken) {
        const res = await getAllFriendsPostApi(this.reqFriendPostsParams)
        this.posts = res.data.list
      }
    } catch (e) {
      this.toast.showToast({
        message: '获取好友动态列表失败',
        duration: 2000,
        alignment: Alignment.Center
      })
    }
  }

  @Builder
  postListBuilder() {
    List({ space: 20 }) {
      ForEach(this.posts, (post: Post.FriendsPost) => {
        ListItem() {
          Column({ space: 5 }) {
            Row({ space: 10 }) {
              Image(post.authorAvatar)
                .clip(true)
                .borderRadius('20%')
                .width(40)
                .height(40)
                .fillColor('#817D83')
              Column({ space: 5 }) {
                Text(post.note ?? post.nickname)
                Text('创建于 ' + post.createTime)
              }
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')

            Column() {
              Text(post.content)
                .onClick(() => {
                  this.pathInfo.param = post
                  this.pathStack.pushPath(this.pathInfo, true)
                })
              if (post.mediaUrls.length === 1) {
                // 处理一张图片或视频时
                Image(post.mediaUrls[0].url)
                  .objectFit(ImageFit.Cover)
                  .width('100%')
                  .fillColor(Color.Gray)
              } else {
                Grid() {
                  ForEach(post.mediaUrls, (item: Post.imgUrls) => {
                    GridItem({
                      style: GridItemStyle.PLAIN
                    }) {
                      Image(item.url)
                        .objectFit(ImageFit.Cover)
                        .width('100%')
                        .height('100%')
                        .fillColor(Color.Gray)
                    }
                    .width('100%')
                    .aspectRatio(1)
                  })
                }
                .width('100%')
                .columnsGap(5)
                .rowsGap(5)
                .columnsTemplate(post.mediaUrls.length === 2 ? '1fr 1fr' : '1fr 1fr 1fr')
              }
              Column({ space: 5 }) {
                Row() {
                  Text('浏览 ' + post.visits + ' 次')
                    .textAlign(TextAlign.Start)
                  Blank()
                  Row({ space: 10 }) {
                    Button({ type: ButtonType.Circle }) {
                      Image(post.isStar ? $r('app.media.star_fill') : $r('app.media.star'))
                        .width(24)
                        .height(24)
                    }
                    .backgroundColor(Color.Transparent)

                    Button({ type: ButtonType.Circle }) {
                      Image(post.isLike ? $r('app.media.like_fill') : $r('app.media.like'))
                      .width(24)
                      .height(24)
                    }
                    .backgroundColor(Color.Transparent)


                    Button({ type: ButtonType.Circle }) {
                      Image($r('app.media.comment'))
                        .width(24)
                        .height(24)
                    }
                    .backgroundColor(Color.Transparent)

                    Button({ type: ButtonType.Circle }) {
                      Image($r('app.media.share'))
                        .width(24)
                        .height(24)
                    }
                    .backgroundColor(Color.Transparent)
                  }
                }
                .width('100%')

                Divider()
                  .strokeWidth(1)
                  .width('100%')
                if (post.likes > 0) {
                  Row() {
                    Text(' 等 ' + post.likes + ' 人觉得很赞')
                      .textAlign(TextAlign.Start)
                  }
                  .width('100%')
                }
              }
              .margin({
                top: 5
              })
              .width('100%')
            }
            .margin({
              top: 5
            })
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }
          .shadow({
            radius: 16,
            offsetX: 5,
            offsetY: 5,
            color: Color.Gray
          })
          .width('95%')
          .margin(5)
          .padding(10)
          .border({
            width: 1,
            radius: 16,
            color: Color.Gray,
            style: BorderStyle.Solid
          })
        }
      })
    }
    .width('100%')
    .height('100%')
  }

  build() {
    Column() {
      this.postListBuilder()
    }
    .onVisibleAreaChange([0, 1], (isExpanding, currentRatio) => {
      if (isExpanding && currentRatio > 0) {
        this.getAllFriendsPosts()
      } else if (!isExpanding && currentRatio == 0) {
        this.posts = []
      }
    })
    .width('100%')
    .height('100%')
  }
}