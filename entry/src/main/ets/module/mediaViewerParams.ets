/**
 * @file: mediaViewerParams.ets
 * @author: Yeluzii
 * @date: 2025/09/15
 */

import { Post } from "../network/interface/post"

export interface MediaViewerParams {
  currentIndex: number
  mediaList: Post.imgUrls[]
  isVisible?: boolean
}