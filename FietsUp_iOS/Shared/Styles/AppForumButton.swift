//
//  ForumButton.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 17/05/2026.
//

import SwiftUI

struct AppForumButton: ButtonStyle {
  var isActive: Bool = false
  
  private var foregroundColor: Color {
    switch isActive {
      case true: Color.Text.Contrasted.primary
      case false: Color.Text.secondary
    }
  }
  
  private var backgroundColor: Color {
    switch isActive {
      case true: Color.Button.primary
      case false: Color.Button.neutral
    }
  }
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .lineLimit(1)
      .font(.caption)
      .foregroundStyle(foregroundColor)
      .padding(.horizontal, 14)
      .padding(.vertical, 10)
      .background(backgroundColor)
      .contentShape(Capsule())
      .clipShape(Capsule())
  }
}
