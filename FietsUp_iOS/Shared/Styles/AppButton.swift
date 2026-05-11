//
//  AppButton.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 11/05/2026.
//

import SwiftUI

struct AppButton: ButtonStyle {
  var role: ButtonRole = .primary
  enum ButtonRole {
    case primary, neutral, destructive
  }
  
  func getBackgroundColor() -> Color {
    switch role {
      case .primary: Color.Button.primary
      case .neutral: Color.Button.neutral
      case .destructive: Color.Button.accent
    }
  }
  
  func getForegroundColor() -> Color {
    switch role {
      case .primary: Color.Text.Contrasted.primary
      case .neutral: Color.Text.primary
      case .destructive: Color.Text.Contrasted.primary
    }
  }

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .multilineTextAlignment(.center)
      .lineLimit(1)
      .font(.caption)
      .foregroundStyle(getForegroundColor())
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
      .background(getBackgroundColor())
      .contentShape(Capsule())
      .clipShape(Capsule())
  }
}

#Preview {
  ZStack {
    Color.gray.ignoresSafeArea()
    
    VStack(spacing: 12) {
      Button("Test"){}
        .buttonStyle(AppButton(role: .primary))
      Button("Test"){}
        .buttonStyle(AppButton(role: .neutral))
      Button("Test"){}
        .buttonStyle(AppButton(role: .destructive))
    }
  }
}
