import http from "../../axios/http"
import { _API } from "../../axios/servicePort"
import { Post } from "../../interface/post"

export const getAllFriendsPostApi = (params: Post.ReqAllFriendsPostParams) => {
  return http.post<Post.ResAllFriendsPostList>(_API + "/post/friends/list", params)
}