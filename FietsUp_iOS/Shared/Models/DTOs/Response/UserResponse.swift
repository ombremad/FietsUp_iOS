//
//  UserResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 12/05/2026.
//

struct UserResponse: Decodable {
  let firstName: String
  let lastName: String
  let nickname: String
  let email: String
  let bio: String?
  let streak: Int
  let daysSinceSignup: Int
  let totalElapsedDistance: Int
}
