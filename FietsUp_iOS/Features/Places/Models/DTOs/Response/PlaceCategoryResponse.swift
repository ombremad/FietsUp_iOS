//
//  PlaceCategoryResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 03/06/2026.
//

import Foundation

struct PlaceCategoryResponse: Decodable, Identifiable {
  let id: UUID
  let name: String
  let iconName: String
}
