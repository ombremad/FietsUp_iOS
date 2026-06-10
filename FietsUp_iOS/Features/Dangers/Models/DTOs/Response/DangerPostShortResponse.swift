//
//  DangerPostShortResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 10/06/2026.
//

import Foundation

struct DangerPostShortResponse: Decodable, Identifiable {
  let id: UUID
  let title: String
  let content: String
  let latitude: Double
  let longitude: Double
  let user: UserPublicResponse
  let creationDate: Date
  let dangerCategory: DangerCategoryResponse
  let totalComments: Int?
}
