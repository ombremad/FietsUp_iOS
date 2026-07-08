//
//  DangerCommentShortResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 08/07/2026.
//

import Foundation

struct DangerCommentShortResponse: Identifiable, Decodable {
  let id: UUID
  let content: String
  let user: UserPublicResponse
  let creationDate: Date
}
