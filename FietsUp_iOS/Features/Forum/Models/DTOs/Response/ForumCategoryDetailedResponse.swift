//
//  ForumCategoryDetailedResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/05/2026.
//

import Foundation

struct ForumCategoryDetailedResponse: Decodable {
  let id: UUID
  let name: String
  let details: String
  let posts: [ForumPostWithCountsResponse]
}
