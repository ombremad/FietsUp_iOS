//
//  ForumCategoryDetailedResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/05/2026.
//

struct ForumCategoryDetailedResponse: Decodable {
  let name: String
  let details: String
  let posts: [ForumPostResponse]
}
