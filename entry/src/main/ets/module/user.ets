export class User {
  public pkId: number;
  public phone: string;
  public nickname: string;
  public slogan: string;
  public avatar: string;
  public createTime: string;
  public tips: string;
  public accessToken: string;

  constructor(
    pkId: number,
    phone: string,
    nickname: string,
    slogan: string,
    avatar: string,
    createTime: string,
    tips: string,
    accessToken: string
  ) {
    this.pkId = pkId;
    this.phone = phone;
    this.nickname = nickname;
    this.slogan = slogan;
    this.avatar = avatar;
    this.createTime = createTime;
    this.tips = tips;
    this.accessToken = accessToken;
  }
}