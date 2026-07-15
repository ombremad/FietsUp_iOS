//
//  UserRights.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/07/2026.
//

import Foundation

enum UserRights: Int, CaseIterable, Comparable {
  case user = 0
  case moderator = 1
  case admin = 2
  
  var name: String {
    switch self {
      case .admin: String(localized: "userRights.admin")
      case .moderator: String(localized: "userRights.moderator")
      case .user: String(localized: "userRights.user")
    }
  }
  
  static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}
