//
//  ValidationService.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 04/05/2026.
//

import Foundation

enum ValidationService {
  static func email(_ email: String) throws {
    try validateNotEmpty(email, field: .email)
    
    let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    guard email.range(of: emailRegex, options: .regularExpression) != nil else {
      throw ValidationError.fieldInvalidFormat(.email)
    }
  }
  
  static func firstName(_ firstName: String) throws {
    try validateName(firstName, field: .firstName)
  }
  
  static func lastName(_ lastName: String) throws {
    try validateName(lastName, field: .lastName)
  }
  
  static func nickname(_ nickname: String) throws {
    try validateName(nickname, field: .nickname)
    
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
  
  private static func validateNotEmpty(_ value: String, field: ValidationError.Field) throws {
    guard !value.isEmpty else {
      throw ValidationError.fieldEmpty(field)
    }
  }
  
  private static func validateName(_ value: String, field: ValidationError.Field, maxLength: Int = 50) throws {
    try validateNotEmpty(value, field: field)
    guard value.count <= maxLength else {
      throw ValidationError.fieldTooLong(field, max: maxLength)
    }
  }
}

enum ValidationError: Error, LocalizedError {
  enum Field {
    case password, email, firstName, lastName, nickname
    
    var localized: String {
      switch self {
        case .password:  return String(localized: "validation.field.password")
        case .email:     return String(localized: "validation.field.email")
        case .firstName: return String(localized: "validation.field.firstName")
        case .lastName:  return String(localized: "validation.field.lastName")
        case .nickname:  return String(localized: "validation.field.nickname")
      }
    }
  }
  
  case fieldEmpty(Field)
  case fieldTooLong(Field, max: Int)
  case fieldNotLongEnough(Field, min: Int)
  case fieldMustBeASCII(Field)
  case fieldMustContainUppercase(Field)
  case fieldMustContainLowercase(Field)
  case fieldMustContainNumber(Field)
  case fieldMustContainSpecialCharacter(Field)
  case fieldInvalidFormat(Field)
  
  case multiple([ValidationError])
  
  var errorDescription: String? {
    switch self {
      case .fieldEmpty(let field):
        return "\(field.localized) \(String(localized: "validation.rule.empty"))"
      case .fieldTooLong(let field, let max):
        return "\(field.localized) \(String(localized: "validation.rule.tooLong \(max)"))"
      case .fieldMustBeASCII(let field):
        return "\(field.localized) \(String(localized: "validation.rule.mustBeASCII"))"
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
      case .fieldInvalidFormat(let field):
        return "\(field.localized) \(String(localized: "validation.rule.isInvalid"))"
        
      case .multiple(let errors):
        let lines = errors.compactMap { $0.errorDescription }.map { "• \($0)" }
        return lines.joined(separator: "\n")
    }
  }
}
