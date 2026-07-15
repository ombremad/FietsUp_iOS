//
//  ModerationCategoryResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 06/07/2026.
//

import Foundation

struct ModerationCategoryResponse: Decodable, Identifiable {
  let id: UUID
  let name: String
}
