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
  
  private(set) var isAuthenticated: Bool
  private(set) var currentUser: User?
  
  private init() {
    self.isAuthenticated = KeychainService.shared.hasToken()
    self.currentUser = nil
  }

  func authenticate(token: String, user: UserResponse) throws {
    try KeychainService.shared.saveToken(token)
    currentUser = User(with: user)
    isAuthenticated = true
  }
  
  func logout() throws {
    try KeychainService.shared.deleteToken()
    currentUser = nil
    isAuthenticated = false
  }
  
  func restoreSession() async {
    guard isAuthenticated, currentUser == nil else { return }
    await forceRefresh()
  }
  
  func forceRefresh() async {
    do {
      let response: UserResponse = try await NetworkService.shared.get(
        endpoint: "/users/me",
        requiresAuth: true
      )
      currentUser = User(with: response)
    } catch NetworkError.unauthorized {
      try? KeychainService.shared.deleteToken()
      isAuthenticated = false
    } catch {
      ErrorService.shared.show(error)
    }
  }
}
