//
//  UserPublicResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 17/05/2026.
//

import Foundation

struct UserPublicResponse: Decodable {
  let id: UUID
  let nickname: String
  let streak: Int
  // TODO: add cycle info
}
