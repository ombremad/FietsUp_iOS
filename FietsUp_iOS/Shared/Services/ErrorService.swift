//
//  ErrorService.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 04/05/2026.
//

import Foundation
import os

@Observable
final class ErrorService {
  static let shared = ErrorService()
  private init() {}
  private let logger = Logger(subsystem: "com.fietsup.app", category: "ErrorService")
  
  var currentError: Error?
  
  func show(_ error: Error) {
    // Note: actions cancelled by the user do not need to trigger a user-facing error,
    // Logging them silently instead.
    if error is CancellationError {
      logger.debug("Task cancelled: \(error)")
      return
    }
    if let urlError = error as? URLError, urlError.code == .cancelled {
      logger.debug("Request cancelled: \(error)")
      return
    }
    
    currentError = error
  }
  
  func dismiss() {
    currentError = nil
  }
}
