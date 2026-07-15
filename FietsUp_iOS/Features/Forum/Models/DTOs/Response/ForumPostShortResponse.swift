//
//  ForumPostShortResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 06/07/2026.
//

import Foundation

struct ForumPostShortResponse: Decodable {
  let id: UUID
  let title: String
  let content: String
  let user: UserPublicResponse
  let creationDate: Date
  let lastActivityDate: Date?
}
