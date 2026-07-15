//
//  ForumCommentShortResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 06/07/2026.
//

import Foundation

struct ForumCommentShortResponse: Decodable {
  let id: UUID
  let content: String
  let user: UserPublicResponse
  let creationDate: Date
}
