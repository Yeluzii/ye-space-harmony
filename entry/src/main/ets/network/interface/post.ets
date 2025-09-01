import type { ReqPage } from "./index";

export namespace Post {
  export interface ReqAllFriendsPostParams extends ReqPage {
    keywords?: string;
  }
  export interface PeopleLikes {
    userId: number;
    nickname: string;
    note?: string;
    avatar: string;
  }
  export interface imgUrls {
    pkId: number;
    url: string;
    type: number;
  }
  export interface FriendsPost {
    pkId: number;
    content: string;
    authorAvatar: string;
    mediaUrls: imgUrls[];
    nickname: string;
    note: string;
    likes: number;
    visits: number;
    createTime: string;
    isLike: boolean;
    isStar: boolean;
    peopleLikes: PeopleLikes[];
  }
  export interface ResAllFriendsPostList {
    total: number;
    list: FriendsPost[];
  }
  export interface ResComment {
    pkId: number;
    parentId: number;
    children: ResComment[];
    name: string;
    respondent: string | null;
    avatar: string;
    content: string;
    imgUrls: [];
    createTime: string;
    permittedToDelete: boolean;
  }
  export interface ReqAddPostParams {
    pkId?: number;
    content: string;
    mediaIds: number[];
    visibility: number;
    allowedUsers: number[];
    blockedUsers: number[];
    isTop: number;
  }
  export interface ReqEditPostParams {
    pkId?: number;
    content: string;
    mediaIds: number[];
    visibility: number;
    allowedUsers: number[];
    blockedUsers: number[];
    isTop: number;
  }
  export interface ReqAddCommentParams {
    postId: number;
    content: string;
    imgIds: number[];
    parentId: number;
  }
}
