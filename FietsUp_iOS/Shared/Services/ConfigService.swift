//
//  ConfigService.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 04/05/2026.
//

import Foundation

enum ConfigService {
  static let apiBaseURL: String = {
    guard let url = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
      fatalError("API_BASE_URL not set in Info.plist")
    }
    return url
  }()
}
