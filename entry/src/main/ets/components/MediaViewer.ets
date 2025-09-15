/**
 * @file: MediaViewer.ets
 * @author: Yeluzii
 * @date: 2025/09/15
 */

import { Post } from "../network/interface/post"
import { PromptAction } from "@kit.ArkUI"

@Component
export struct MediaViewer {
  videoController: VideoController = new VideoController()
  // 媒体资源数组
  @Prop
  mediaList: Post.imgUrls[] = []
  // 当前显示的媒体索引
  @Prop
  currentIndex: number = 0
  // 是否显示查看器
  @Link
  isVisible: boolean
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

  build() {
    Column() {
      // 顶部信息栏
      Row() {
        Text(`${this.currentIndex + 1}/${this.mediaList.length}`)
          .fontColor(Color.Black)
          .fontSize(16)
          .padding(10)
      }
      .width('100%')
      .backgroundColor('#00000030')
      .zIndex(1)

      // 媒体内容区域
      Column() {
        Swiper() {
          ForEach(this.mediaList, (item: Post.imgUrls, index) => {
            // 图片
            if (item.type === 0) {
              Image(item.url)
                .alt($r('app.media.picture_damage'))
                .objectFit(ImageFit.Contain)
                .width('100%')
                .height('100%')
            }
            // 视频
            else if (item.type === 1) {
              Video({
                src: item.url,
                controller: this.videoController
              })
                .controls(true)
                .autoPlay(this.currentIndex === index)
                .objectFit(ImageFit.Contain)
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
      }
      .offset({
        x: this.offsetX,
        y: this.offsetY
      })
      // .transform([
      //   { translate: { x: 0, y: this.offsetY } },
      //   { scale: { x: this.mediaScale, y: this.mediaScale } }
      // ])
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
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
            // 关闭查看器
            this.isVisible = false
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
    .zIndex(9999)
    .opacity(this.mediaOpacity)
  }
}
