//
//  DangerCommentResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 10/06/2026.
//

import Foundation

struct DangerCommentResponse: Identifiable, Decodable {
  let id: UUID
  let content: String
  let user: UserPublicResponse
  let creationDate: Date
  let likeCount: Int
  let likedByUser: Bool
  let favedByUser: Bool
}
