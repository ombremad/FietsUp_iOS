//
//  DangerCategoryResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 08/06/2026.
//

import Foundation

struct DangerCategoryResponse: Identifiable, Decodable {
  let id: UUID
  let name: String
  let iconName: String
}
