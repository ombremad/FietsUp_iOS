//
//  User.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 12/05/2026.
//

final class User {
  var firstName: String
  var lastName: String
  var nickname: String
  var email: String
  var bio: String?
  var streak: Int
  var daysSinceSignup: Int
  var totalElapsedDistance: Int

  init(with dto: UserResponse) {
    self.firstName = dto.firstName
    self.lastName = dto.lastName
    self.nickname = dto.nickname
    self.email = dto.email
    self.bio = dto.bio
    self.streak = dto.streak
    self.daysSinceSignup = dto.daysSinceSignup
    self.totalElapsedDistance = dto.totalElapsedDistance
  }
}
