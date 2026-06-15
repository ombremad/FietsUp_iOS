//
//  ConvertHexToSwiftColor.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/06/2026.
//

import SwiftUI

extension Color {
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
      .replacingOccurrences(of: "#", with: "")
    
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    
    let r = Double((int >> 16) & 0xFF) / 255.0
    let g = Double((int >> 8) & 0xFF) / 255.0
    let b = Double(int & 0xFF) / 255.0
    
    self.init(red: r, green: g, blue: b)
  }
}
