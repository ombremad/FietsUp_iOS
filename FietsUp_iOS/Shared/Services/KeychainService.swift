//
//  KeychainService.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 04/05/2026.
//

import Foundation
import Security

final class KeychainService {
  static let shared = KeychainService()
  private init() {}  
  private let service = Bundle.main.bundleIdentifier ?? "ombremad.FietsUp-iOS"
  private let tokenKey = "authToken"
  
  func saveToken(_ token: String) throws {
    let data = Data(token.utf8)
    
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: tokenKey,
      kSecValueData as String: data
    ]
    
    SecItemDelete(query as CFDictionary)
    
    let status = SecItemAdd(query as CFDictionary, nil)
    
    guard status == errSecSuccess else {
      throw KeychainError.unknown(status)
    }
  }
  
  func getToken() throws -> String? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: tokenKey,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne
    ]
    
    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)
    
    guard status == errSecSuccess else {
      if status == errSecItemNotFound {
        return nil
      }
      throw KeychainError.unknown(status)
    }
    
    guard let data = result as? Data,
          let token = String(data: data, encoding: .utf8) else {
      throw KeychainError.invalidData
    }
    
    return token
  }
  
  func deleteToken() throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: tokenKey
    ]
    
    let status = SecItemDelete(query as CFDictionary)
    
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw KeychainError.unknown(status)
    }
  }
  
  func hasToken() -> Bool {
    return (try? getToken()) != nil
  }
}

enum KeychainError: Error {
  case unknown(OSStatus)
  case invalidData
}
