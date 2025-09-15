/**
 * @file: MediaViewer.ets
 * @author: Yeluzii
 * @date: 2025/09/15
 */

import { Post } from "../network/interface/post"
import { AppStorageV2, PromptAction } from "@kit.ArkUI"
import { MediaViewerParams } from "../module/mediaViewerParams"

@Builder
export function MediaViewerBuilder() {
  MediaViewerPage()
}

@Component
struct MediaViewerPage {
  videoController: VideoController = new VideoController()
  // 用于显示提示信息
  private toast: PromptAction = new PromptAction()
  // 拖拽相关状态
  @State offsetX: number = 0
  @State offsetY: number = 0
  panOption: PanGestureOptions = new PanGestureOptions()
  @State mediaScale: number = 1
  @State mediaOpacity: number = 1
  // 记录初始缩放值，用于拖拽时恢复
  @State initialScale: number = 1
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!
  mediaPathInfo: NavPathInfo = AppStorageV2.connect(NavPathInfo, 'mediaPathInfo')!
  @State mediaParams: MediaViewerParams = this.mediaPathInfo.param as MediaViewerParams
  // 媒体资源数组
  @State
  mediaList: Post.imgUrls[] = []
  // 当前显示的媒体索引
  @State
  currentIndex: number = 0

  aboutToAppear(): void {
    this.mediaList = this.mediaParams.mediaList
    this.currentIndex = this.mediaParams.currentIndex
  }

  build() {
    NavDestination() {

      Column() {
        // 媒体内容区域
        Stack({ alignContent: Alignment.Bottom }) {
          Swiper() {
            ForEach(this.mediaList, (item: Post.imgUrls, index) => {
              // 图片
              if (item.type === 0) {
                Image(item.url)
                  .alt($r('app.media.picture_damage'))
                  .objectFit(ImageFit.Contain)
                  .width('100%')
                  .height('100%')
                  .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
              }
              // 视频
              else if (item.type === 1) {
                Video({
                  src: item.url,
                  controller: this.videoController
                })
                  .objectFit(ImageFit.Fill)
                  .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
                  .controls(true)
                  .autoPlay(this.currentIndex === index)
                  .width('100%')
                  .height('100%')
                  .onError(() => {
                    this.toast.showToast({
                      message: '视频加载失败',
                      duration: 2000
                    })
                  })
              }
            })
          }
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
          .index(this.currentIndex)
          .onChange((index: number) => {
            this.videoController.pause()
            this.currentIndex = index
          })
          // 禁用循环
          .loop(false)
          // 隐藏指示器
          .indicator(false)
          .duration(300)

          // 底部信息栏
          Column() {
            Text(`${this.currentIndex + 1}/${this.mediaList.length}`)
              .fontColor(Color.Black)
              .fontSize(16)
              .padding(5)
              .width('55vp')
              .backgroundColor('rgba(233,233,233,0.5)')
              .border({
                radius: 10
              })
              .textAlign(TextAlign.Center)
          }
          .offset({ y: -30 })
          .alignItems(HorizontalAlign.Center)
          .width('100%')
        }
        .zIndex(999)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .width('100%')
        .height('100%')
        .offset({
          x: this.offsetX,
          y: this.offsetY
        })

        // .transform([
        //   { translate: { x: 0, y: this.offsetY } },
        //   { scale: { x: this.mediaScale, y: this.mediaScale } }
        // ])
      }
      .gesture(
        PanGesture(this.panOption)
          .onActionStart((event: GestureEvent) => {
            this.initialScale = this.mediaScale
          })
          .onActionUpdate((event: GestureEvent) => {
            // 当前拖拽偏移量
            this.offsetX = event.offsetX
            this.offsetY = event.offsetY

            // 根据拖拽距离计算透明度 (拖拽距离越远，透明度越低)
            // 最大拖拽距离设为屏幕高度的1/3，超过这个距离就完全透明
            const maxDragDistance = 300
            const opacityRatio = 1 - Math.abs(this.offsetY) / maxDragDistance
            this.mediaOpacity = Math.max(0, Math.min(1, opacityRatio))

            // 根据拖拽距离计算缩放比例 (拖拽距离越远，缩放越小)
            const scaleRatio = 1 - Math.abs(this.offsetY) / (maxDragDistance * 2)
            this.mediaScale = Math.max(0.8, Math.min(1, scaleRatio)) * this.initialScale
          })
          .onActionEnd((event: GestureEvent) => {
            // 拖拽结束时判断是否需要关闭查看器
            const dismissThreshold = 150 // 触发关闭的阈值
            if (Math.abs(this.offsetY) > dismissThreshold) {
              this.pathStack.pop(false)
            } else {
              // 否则恢复原位
              this.offsetX = 0
              this.offsetY = 0
              this.mediaOpacity = 1
              this.mediaScale = this.initialScale
            }
          })
          .onActionCancel(() => {
            // 拖拽被取消时恢复原位
            this.offsetX = 0
            this.offsetY = 0
            this.mediaOpacity = 1
            this.mediaScale = this.initialScale
          })
      )
      .width('100%')
      .height('100%')
      .backgroundColor(`rgba(233, 233, 233, ${this.mediaOpacity})`)
      .position({ x: 0, y: 0 })
      .opacity(this.mediaOpacity)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}
