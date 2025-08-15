import { Friend } from '../../interface/friend'
import http from "../../axios/http"
import { _API } from "../../axios/servicePort"

// 获取好友分组列表
export const getFriendCategoriesApi = () => {
  return http.post<Friend.ResFriendCategories[]>(_API + `/friend/category/list`);
};

// 获取好友列表
export const getFriendListApi = (params: Friend.ReqFriendList) => {
  return http.post<Friend.ResFriendList>(_API + `/friend/list`, params);
};
