//
//  ValidationService.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 04/05/2026.
//

import Foundation

enum ValidationService {
  private static let emailRegex = #"""
    ^(?!\.)((?!.*\.{2})[a-zA-Z0-9...]+)@(?!\.)([a-zA-Z0-9...]+)((\.([a-zA-Z...]){2,63})+)$
    """#

  static func email(_ email: String) throws {
    try validateLength(email, field: .email, min: 1)
    
    guard email.range(of: emailRegex, options: .regularExpression) != nil else {
      throw ValidationError.fieldInvalidFormat(.email)
    }
  }
  
  static func firstName(_ firstName: String) throws {
    try validateLength(firstName, field: .firstName, min: 1, max: 50)
  }
  
  static func lastName(_ lastName: String) throws {
    try validateLength(lastName, field: .lastName, min: 1, max: 50)
  }
  
  static func nickname(_ nickname: String) throws {
    try validateLength(nickname, field: .nickname, min: 1, max: 50)
    
    guard nickname.allSatisfy(\.isASCII) else {
      throw ValidationError.fieldMustBeASCII(.nickname)
    }
  }

  static func password(_ password: String) throws {
    var failures: [ValidationError] = []
    
    if password.count < 8 {
      failures.append(.fieldNotLongEnough(.password, min: 8))
    }
    if password.range(of: "[A-Z]", options: .regularExpression) == nil {
      failures.append(.fieldMustContainUppercase(.password))
    }
    if password.range(of: "[a-z]", options: .regularExpression) == nil {
      failures.append(.fieldMustContainLowercase(.password))
    }
    if password.range(of: "[0-9]", options: .regularExpression) == nil {
      failures.append(.fieldMustContainNumber(.password))
    }
    if password.range(of: "[^A-Za-z0-9]", options: .regularExpression) == nil {
      failures.append(.fieldMustContainSpecialCharacter(.password))
    }
    
    guard failures.isEmpty else {
      throw ValidationError.multiple(failures)
    }
  }
  
  static func activityDates(start: Date, end: Date) throws {
    if start > end {
      throw ValidationError.startMustBeBeforeEnd
    }
    
    let length = end.timeIntervalSince(start) / 60

    if length <= 0 {
      throw ValidationError.fieldCannotBeZero(.length)
    }
    if length > 1440 { // 24 hours
      throw ValidationError.fieldMustBeReasonable(.length)
    }
  }
  
  static func distance(_ distance: Int) throws {
    if distance <= 0 {
      throw ValidationError.fieldCannotBeZero(.distance)
    }
    if distance > 720000 {
      throw ValidationError.fieldMustBeReasonable(.distance)
    }
  }
  
  static func passwordConfirmation(password: String, confirmation: String) throws {
    guard password == confirmation else {
      throw ValidationError.fieldConfirmationMustBeIdentical(.password)
    }
  }
  
  private static func validateLength(
    _ value: String,
    field: ValidationError.Field,
    min: Int? = nil,
    max: Int? = nil
  ) throws {
    if let min, value.count < min {
      throw ValidationError.fieldNotLongEnough(field, min: min)
    }
    if let max, value.count > max {
      throw ValidationError.fieldTooLong(field, max: max)
    }
  }
}

enum ValidationError: Error, LocalizedError {
  enum Field {
    case password, email, firstName, lastName, nickname, length, distance
    
    var localized: String {
      switch self {
        case .password: return String(localized: "validation.field.password")
        case .email: return String(localized: "validation.field.email")
        case .firstName: return String(localized: "validation.field.firstName")
        case .lastName: return String(localized: "validation.field.lastName")
        case .nickname: return String(localized: "validation.field.nickname")
        case .length: return String(localized: "validation.field.length")
        case .distance: return String(localized: "validation.field.distance")
      }
    }
  }
  
  case fieldCannotBeZero(Field)
  case fieldTooLong(Field, max: Int)
  case fieldNotLongEnough(Field, min: Int)
  case fieldMustContainUppercase(Field)
  case fieldMustContainLowercase(Field)
  case fieldMustContainNumber(Field)
  case fieldMustContainSpecialCharacter(Field)
  case fieldMustBeASCII(Field)
  case fieldInvalidFormat(Field)
  case fieldConfirmationMustBeIdentical(Field)
  case fieldMustBeReasonable(Field)
  case startMustBeBeforeEnd
  
  case multiple([ValidationError])
  
  var errorDescription: String? {
    switch self {
      case .fieldCannotBeZero(let field):
        return "\(field.localized) \(String(localized: "validation.rule.cannotBeZero"))"
      case .fieldTooLong(let field, let max):
        return "\(field.localized) \(String(localized: "validation.rule.tooLong \(max)"))"
      case .fieldNotLongEnough(let field, let min):
        return "\(field.localized) \(String(localized: "validation.rule.notLongEnough \(min)"))"
      case .fieldMustContainUppercase(let field):
        return "\(field.localized) \(String(localized: "validation.rule.mustContainUppercase"))"
      case .fieldMustContainLowercase(let field):
        return "\(field.localized) \(String(localized: "validation.rule.mustContainLowercase"))"
      case .fieldMustContainNumber(let field):
        return "\(field.localized) \(String(localized: "validation.rule.mustContainNumber"))"
      case .fieldMustContainSpecialCharacter(let field):
        return "\(field.localized) \(String(localized: "validation.rule.mustContainSpecialCharacter"))"
      case .fieldMustBeASCII(let field):
        return "\(field.localized) \(String(localized: "validation.rule.mustBeASCII"))"
      case .fieldInvalidFormat(let field):
        return "\(field.localized) \(String(localized: "validation.rule.isInvalid"))"
      case .fieldConfirmationMustBeIdentical(let field):
        return "\(field.localized) \(String(localized: "validation.rule.confirmationMustBeIdentical"))"
      case .fieldMustBeReasonable(let field):
        return "\(field.localized) \(String(localized: "validation.rule.mustBeReasonable"))"
      case .startMustBeBeforeEnd:
        return String(localized: "validation.rule.startMustBeBeforeEnd")

      case .multiple(let errors):
        let lines = errors.compactMap { $0.errorDescription }.map { "• \($0)" }
        return lines.joined(separator: "\n")
    }
  }
}
