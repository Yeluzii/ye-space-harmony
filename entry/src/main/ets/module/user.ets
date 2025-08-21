export class User {
  public pkId: number;
  public phone: string;
  public nickname: string;
  public slogan: string;
  public avatar: string;
  public createTime: string;
  public tips: string;
  public accessToken: string;
  public lastLoginTime: string;
  public bgImg: string;

  constructor(
    pkId: number,
    phone: string,
    nickname: string,
    slogan: string,
    avatar: string,
    createTime: string,
    tips: string,
    accessToken: string,
    lastLoginTime: string,
    bgImg: string
  ) {
    this.pkId = pkId;
    this.phone = phone;
    this.nickname = nickname;
    this.slogan = slogan;
    this.avatar = avatar;
    this.createTime = createTime;
    this.tips = tips;
    this.accessToken = accessToken;
    this.lastLoginTime = lastLoginTime;
    this.bgImg = bgImg;
  }
}