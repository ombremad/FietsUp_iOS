//
//  ThemeService.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/06/2026.
//

import SwiftUI

@Observable
final class ThemeService {
  static let shared = ThemeService()
  
  var setting: ThemeSetting {
    didSet {
      UserDefaults.standard.set(setting.rawValue, forKey: "themeSetting")
    }
  }
  
  private init() {
    let raw = UserDefaults.standard.string(forKey: "themeSetting") ?? "auto"
    self.setting = ThemeSetting(rawValue: raw) ?? .auto
  }

  var colorScheme: ColorScheme? {
    switch setting {
      case .auto: nil
      case .light: .light
      case .dark: .dark
    }
  }
}

enum ThemeSetting: String, CaseIterable {
  case auto, light, dark
  
  var label: LocalizedStringKey {
    switch self {
      case .auto: "settings.theme.automatic"
      case .light: "settings.theme.light"
      case .dark: "settings.theme.dark"
    }
  }
}
