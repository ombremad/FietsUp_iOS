//
//  AuthService.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 04/05/2026.
//

import Foundation

@Observable
final class AuthService {
  static let shared = AuthService()
  private init() { self.isAuthenticated = KeychainService.shared.hasToken() }
  var isAuthenticated: Bool = false
  
  func markAsAuthenticated(token: String) throws {
    try KeychainService.shared.saveToken(token)
    isAuthenticated = true
    print("User logged in")
  }
  
  func logout() throws {
    try KeychainService.shared.deleteToken()
    isAuthenticated = false
    print("User logged out")
  }
}
