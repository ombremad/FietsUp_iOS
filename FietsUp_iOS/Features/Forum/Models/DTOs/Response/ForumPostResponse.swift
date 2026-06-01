//
//  ForumPostResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 17/05/2026.
//

import Foundation

struct ForumPostResponse: Decodable {
  let id: UUID
  let title: String
  let content: String
  let user: UserPublicResponse
  let creationDate: Date
  let likeCount: Int
  let likedByUser: Bool
  let favedByUser: Bool
  let comments: [ForumCommentResponse]
}
