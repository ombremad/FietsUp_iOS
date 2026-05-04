//
//  ErrorService.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 04/05/2026.
//

import Foundation

@Observable
final class ErrorService {
  static let shared = ErrorService()
  private init() {}
  
  var currentError: Error?
  
  func show(_ error: Error) {
    currentError = error
  }
  
  func dismiss() {
    currentError = nil
  }
}
