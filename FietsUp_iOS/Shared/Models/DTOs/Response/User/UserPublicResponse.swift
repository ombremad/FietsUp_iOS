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
  let daysSinceSignup: Int
  let totalElapsedDistance: Int
  let bio: String?
  // TODO: add cycle info
}
