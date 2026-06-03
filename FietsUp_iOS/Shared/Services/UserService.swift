//
//  UserSession.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 12/05/2026.
//

import Foundation

@Observable
final class UserService {
    static let shared = UserService()
    private init() {}
    
    var current: User?
    var isAuthenticated: Bool { current != nil }
}
