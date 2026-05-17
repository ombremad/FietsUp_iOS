//
//  ForumPostResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/05/2026.
//

import Foundation

struct ForumPostShortResponse: Decodable, Identifiable {
  let id: UUID
  let user: UserShortResponse
  let title: String
  let content: String
  let totalComments: Int
  let lastActivityDate: Date?
}
