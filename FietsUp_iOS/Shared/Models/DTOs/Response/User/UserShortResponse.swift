//
//  UserShortResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/05/2026.
//

import Foundation

struct UserShortResponse: Decodable {
  let id: UUID
  let nickname: String
  let streak: Int
}
