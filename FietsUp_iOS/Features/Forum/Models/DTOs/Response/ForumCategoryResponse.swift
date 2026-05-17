//
//  ForumCategoryResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/05/2026.
//

import Foundation

struct ForumCategoryResponse: Decodable, Identifiable {
  let id: UUID
  let name: String
  let details: String
  let totalPosts: Int
  let lastActivityDate: Date?
}
