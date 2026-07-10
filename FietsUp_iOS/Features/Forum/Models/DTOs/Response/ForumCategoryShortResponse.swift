//
//  ForumCategoryShortResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 10/07/2026.
//

import Foundation

struct ForumCategoryShortResponse: Decodable, Identifiable {
  let id: UUID
  let name: String
  let details: String
}
