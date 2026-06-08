//
//  Placeholders.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 08/06/2026.
//

import Foundation

enum PlaceholderData {
  static let firstName = "Paul"
  static let lastName = "Jean-Paul"
  static let nickname = "veliste_du_31"
  static let email = "jeanpaulveliste@example.com"
  static let bio = "Je fais du vélo et c'est ma grande joie"
  static let streak = 12
  static let daysSinceSignup = 200
  static let totalElapsedDistance = 42_000
}

extension UserResponse {
  static let placeholder = UserResponse(firstName: PlaceholderData.firstName, lastName: PlaceholderData.lastName, nickname: PlaceholderData.nickname, email: PlaceholderData.nickname, bio: PlaceholderData.bio, streak: PlaceholderData.streak, daysSinceSignup: PlaceholderData.daysSinceSignup, totalElapsedDistance: PlaceholderData.totalElapsedDistance)
}

extension UserPublicResponse {
  static let placeholder = UserPublicResponse(id: UUID(), nickname: PlaceholderData.nickname, streak: PlaceholderData.streak, daysSinceSignup: PlaceholderData.daysSinceSignup, totalElapsedDistance: PlaceholderData.totalElapsedDistance, bio: PlaceholderData.bio)
}

extension User {
  static let placeholder = User(with: .placeholder)
}
