@Component
export struct FriendPage {
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