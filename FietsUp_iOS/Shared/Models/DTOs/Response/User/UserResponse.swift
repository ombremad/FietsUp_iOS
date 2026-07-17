//
//  UserResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 12/05/2026.
//

import Foundation

struct UserResponse: Decodable, Identifiable {
  let id: UUID
  let firstName: String
  let lastName: String
  let nickname: String
  let email: String
  let bio: String?
  let streak: Int
  let daysSinceSignup: Int
  let totalElapsedDistance: Int
  let cycleType: CycleTypeResponse?
  let cycleColor: CycleColorResponse?
  let cycleDecoration: CycleDecorationResponse?
  let adminRights: Int
  let banEndDate: Date?
}
