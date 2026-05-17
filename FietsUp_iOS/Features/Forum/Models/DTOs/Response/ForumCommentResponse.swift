//
//  ForumCommentResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 17/05/2026.
//

import Foundation

struct ForumCommentResponse: Decodable, Identifiable {
  let id: UUID
  let content: String
  let user: UserPublicResponse
  let creationDate: Date
  let likeCount: Int
  let likedByUser: Bool
  let favedByUser: Bool
}
