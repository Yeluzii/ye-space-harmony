import { Login as LoginModel } from "../network/interface"
import { passwordLoginApi, codeLoginApi, sendCodeApi } from "../network/api/login"
import { PromptAction } from '@kit.ArkUI'
import { User } from "../module/user"

@Builder
export function LoginBuilder() {
  Login()
}

@Component
struct Login {
  pathStack: NavPathStack = new NavPathStack()
  @State
  passwordLoginForm: LoginModel.ReqPasswordLoginParams = {
    phone: "",
    password: ""
  }
  @State
  codeLoginForm: LoginModel.ReqCodeLoginParams = {
    phone: "",
    code: ""
  }
  @State
  loginState: boolean = true
  toast: PromptAction = new PromptAction()
  @State
  user: User = new User(0, "", "", "", "", "", "", "")
  // 账号（手机号）密码登录
  passwordLogin = async () => {
    try {
      const res = await passwordLoginApi(this.passwordLoginForm)
      this.user = new User(res.data.pkId, res.data.phone, res.data.nickname, res.data.slogan, res.data.avatar,
        res.data.createTime, res.data.tips, res.data.accessToken)
      AppStorage.setOrCreate('user', this.user)
      this.toast.showToast({
        message: "登录成功",
        duration: 2000,
        alignment: Alignment.Top
      })
      this.pathStack.pop()
    } catch (e) {
      this.toast.showToast({
        message: "登录失败",
        duration: 2000,
        alignment: Alignment.Top
      })
    }
  }
  // 手机号验证码登录
  codeLogin = async () => {
    try {
      const res = await codeLoginApi(this.codeLoginForm)
      this.user = new User(res.data.pkId, res.data.phone, res.data.nickname, res.data.slogan, res.data.avatar,
      res.data.createTime, res.data.tips, res.data.accessToken)
      AppStorage.setOrCreate('user', this.user)
      this.toast.showToast({
        message: "登录成功",
        duration: 2000,
        alignment: Alignment.Top
      })
      this.pathStack.pop()
    } catch (e) {
      this.toast.showToast({
        message: "登录失败",
        duration: 2000,
        alignment: Alignment.Top
      })
    }
  }

  @State
  countDown: number = 0
  @State
  isCounting: boolean = false
  // 开始倒计时
  startCountDown = () => {
    this.countDown = 60; // 设置60秒倒计时
    this.isCounting = true;

    const timer = setInterval(() => {
      this.countDown--;
      if (this.countDown <= 0) {
        clearInterval(timer);
        this.isCounting = false;
      }
    }, 1000);
  }

  // 发送验证码
  sendCode = async () => {
    try {
      this.startCountDown()
      await sendCodeApi(this.passwordLoginForm.phone)
      this.toast.showToast({
        message: `验证码已发送至 ${this.codeLoginForm.phone} ,注意查收`,
        duration: 3000,
        alignment: Alignment.Top
      })
    } catch (e) {
      this.toast.showToast({
        message: "验证码发送失败",
        duration: 2000,
        alignment: Alignment.Top
      })
    }
  }

  build() {
    NavDestination() {
      if (this.loginState) {
        Column({ space: 10 }) {
          Text('登录')
            .fontSize('50vp')
            .fontColor(Color.Black)

          Column({ space: 10 }) {
            TextInput({ placeholder: "请输入手机号" })
              .placeholderColor(Color.Gray)
              .onChange((value: string) => {
                this.passwordLoginForm.phone = value
              })
            TextInput({ placeholder: "请输入密码" })
              .placeholderColor(Color.Gray)
              .onChange((value: string) => {
                this.passwordLoginForm.password = value
              })
          }
          .width('80%')

          Button("登录")
            .onClick(() => {
              this.passwordLogin()
            })
          Text("还没有账号？去注册 ->")
            .decoration({ type: TextDecorationType.Underline })
            .onClick(() => {
              this.loginState = false
            })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      } else {
        Column({ space: 10 }) {
          Text('注册')
            .fontSize('50vp')
            .fontColor(Color.Black)

          Column({ space: 10 }) {
            TextInput({ placeholder: "请输入手机号" })
              .placeholderColor(Color.Gray)
              .onChange((value: string) => {
                this.codeLoginForm.phone = value
              })
            Row() {
              TextInput({ placeholder: "请输入验证码" })
                .layoutWeight(1)
                .placeholderColor(Color.Gray)
                .onChange((value: string) => {
                  this.codeLoginForm.code = value
                })
              Button(this.isCounting ? `${this.countDown}s 后重新发送` : "发送验证码")
                .onClick(() => {
                  this.sendCode()
                })
                .enabled(!this.isCounting) // 倒计时期间禁用按钮
            }
            .width('100%')
          }
          .width('80%')

          Button("一键登录/注册")
            .onClick(() => {
              this.codeLogin()
            })
          Text("去登录")
            .decoration({ type: TextDecorationType.Underline })
            .onClick(() => {
              this.loginState = true
            })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      }
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
    .hideTitleBar(true)
  }
}