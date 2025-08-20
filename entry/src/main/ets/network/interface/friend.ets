import  { ReqPage } from ".";

export namespace Friend {
  export interface ReqFriendList extends ReqPage {
    keywords?: string;
    categoryId?: number;
  }
  export interface FriendInfo {
    friendId: number;
    phone: string;
    nickname: string;
    note?: string | null;
    slogan: string;
    avatar: string;
    createTime: string;
  }
  export interface ResFriendList {
    total: number;
    list: FriendInfo[];
  }
  export interface ResFriendCategories {
    pkId: number;
    name: string;
  }
}