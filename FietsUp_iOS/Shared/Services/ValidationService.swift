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
  
  static func bio(_ bio: String) throws {
    try validateLength(bio, field: .bio, max: 500)
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
  
  static func passwordConfirmation(password: String, confirmation: String) throws {
    guard password == confirmation else {
      throw ValidationError.fieldConfirmationMustBeIdentical(.password)
    }
  }
  
  static func title(_ title: String) throws {
    try validateLength(title, field: .title, min: 1, max: 100)
  }
  
  static func name(_ name: String) throws {
    try validateLength(name, field: .name, min: 1, max: 50)
  }
  
  static func details(_ details: String) throws {
    try validateLength(details, field: .details, min: 1, max: 10000)
  }
  
  static func content(_ content: String) throws {
    try validateLength(content, field: .content, min: 1, max: 20000)
  }
    
  static func activityDates(start: Date, end: Date) throws {
    try validatePastDate(start, field: .startDate)
    try validatePastDate(end, field: .endDate)
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
  
  static func location(latitude: Double?, longitude: Double?) throws {
    guard let latitude, let longitude else {
      throw ValidationError.locationFailed
    }
    if latitude > 90 || latitude < -90 {
      throw ValidationError.fieldInvalidFormat(.latitude)
    }
    if longitude > 180 || longitude < -180 {
      throw ValidationError.fieldInvalidFormat(.longitude)
    }
  }
  
  static func categoryId(_ categoryId: UUID?) throws {
    guard categoryId != nil else {
      throw ValidationError.fieldCannotBeEmpty(.category)
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
  
  static func reportDetails(_ details: String) throws {
    try validateLength(details, field: .reportDetails, min: 1, max: 10000)
  }
  
  static func banDate(_ date: Date) throws {
    try validateFutureDate(date, field: .banEndDate)
  }
      
  static func iconName(_ iconName: String) throws {
    guard SFSymbolCatalog.shared.contains(iconName) else {
      throw ValidationError.fieldIsNotASFSymbol(.iconName)
    }
  }
  
  static func placeCategories(_ categories: [PlaceCategoryResponse]) throws {
    guard !categories.isEmpty else {
      throw ValidationError.fieldCannotBeEmpty(.placeCategories)
    }
  }
  
  static func address(_ address: String) throws {
    try validateLength(address, field: .address, min: 1, max: 100)
  }
  
  static func zipCode(_ zipCode: String) throws {
    try validateLength(zipCode, field: .zipCode, min: 1, max: 6)
  }
  
  static func city(_ city: String) throws {
    try validateLength(city, field: .city, min: 1, max: 50)
  }
  
  static func country(_ country: String) throws {
    try validateLength(country, field: .country, min: 1, max: 50)
  }
  
  static func phoneNumber(_ phoneNumber: String) throws {
    try validateLength(phoneNumber, field: .phoneNumber, min: 4, max: 16)
    
    guard phoneNumber.range(of: #"^\+?[0-9]+$"#, options: .regularExpression) != nil else {
      throw ValidationError.fieldInvalidFormat(.phoneNumber)
    }
  }
  
  static func website(_ website: String) throws {
    try validateLength(website, field: .website, min: 1, max: 100)
    
    guard
      let url = URL(string: website),
      url.isFileURL || (url.host != nil && url.scheme != nil)
    else {
      throw ValidationError.fieldInvalidFormat(.website)
    }
  }
  
  static func otherDetails(_ otherDetails: String) throws {
    try validateLength(otherDetails, field: .otherDetails, min: 1, max: 10000)
  }
  
  private static func validatePastDate(_ date: Date, field: ValidationError.Field) throws {
    let now = Date.now
    if date > now { throw ValidationError.fieldCannotBeInTheFuture(field) }
  }
  
  private static func validateFutureDate(_ date: Date, field: ValidationError.Field) throws {
    let now = Date.now
    if date <= now { throw ValidationError.fieldCannotBeInThePast(field) }
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
    case password, email, firstName, lastName, nickname, bio, title, name, details, content, length, distance, latitude, longitude, category, reportDetails, startDate, endDate, banEndDate, iconName, placeCategories, address, zipCode, city, country, phoneNumber, website, otherDetails
    
    var localized: String {
      switch self {
        case .password: return String(localized: "validation.field.password")
        case .email: return String(localized: "validation.field.email")
        case .firstName: return String(localized: "validation.field.firstName")
        case .lastName: return String(localized: "validation.field.lastName")
        case .nickname: return String(localized: "validation.field.nickname")
        case .bio: return String(localized: "validation.field.bio")
        case .title: return String(localized: "validation.field.title")
        case .name: return String(localized: "validation.field.name")
        case .details: return String(localized: "validation.field.details")
        case .content: return String(localized: "validation.field.content")
        case .length: return String(localized: "validation.field.length")
        case .distance: return String(localized: "validation.field.distance")
        case .latitude: return String(localized: "validation.field.latitude")
        case .longitude: return String(localized: "validation.field.longitude")
        case .category: return String(localized: "validation.field.category")
        case .reportDetails: return String(localized: "validation.field.reportDetails")
        case .startDate: return String(localized: "validation.field.startDate")
        case .endDate: return String(localized: "validation.field.endDate")
        case .banEndDate: return String(localized: "validation.field.banEndDate")
        case .iconName: return String(localized: "validation.field.iconName")
        case .placeCategories: return String(localized: "validation.field.placeCategories")
        case .address: return String(localized: "validation.field.address")
        case .zipCode: return String(localized: "validation.field.zipCode")
        case .city: return String(localized: "validation.field.city")
        case .country: return String(localized: "validation.field.country")
        case .phoneNumber: return String(localized: "validation.field.phoneNumber")
        case .website: return String(localized: "validation.field.website")
        case .otherDetails: return String(localized: "validation.field.otherDetails")
      }
    }
  }
  
  case fieldCannotBeZero(Field)
  case fieldCannotBeEmpty(Field)
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
  case fieldCannotBeInTheFuture(Field)
  case fieldCannotBeInThePast(Field)
  case fieldIsNotASFSymbol(Field)
  case startMustBeBeforeEnd
  case locationFailed
  
  case multiple([ValidationError])
  
  var errorDescription: String? {
    switch self {
      case .fieldCannotBeZero(let field):
        return "\(field.localized) \(String(localized: "validation.rule.cannotBeZero"))"
      case .fieldCannotBeEmpty(let field):
        return "\(field.localized) \(String(localized: "validation.rule.cannotBeEmpty"))"
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
      case .fieldCannotBeInTheFuture(let field):
        return "\(field.localized) \(String(localized: "validation.rule.cannotBeInTheFuture"))"
      case .fieldCannotBeInThePast(let field):
        return "\(field.localized) \(String(localized: "validation.rule.cannotBeInThePast"))"
      case .fieldIsNotASFSymbol(let field):
        return "\(field.localized) \(String(localized: "validation.rule.isNotASFSymbol"))"
      case .startMustBeBeforeEnd:
        return String(localized: "validation.rule.startMustBeBeforeEnd")
      case .locationFailed:
        return String(localized: "validation.rule.locationFailed")

      case .multiple(let errors):
        let lines = errors.compactMap { $0.errorDescription }.map { "• \($0)" }
        return lines.joined(separator: "\n")
    }
  }
}
