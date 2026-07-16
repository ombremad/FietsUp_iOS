//
//  AppLabelButton.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 11/05/2026.
//

import SwiftUI

struct AppLabelButton: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .multilineTextAlignment(.center)
      .lineLimit(1)
      .font(.caption)
      .foregroundStyle(Color.Text.Contrasted.primary)
      .padding(Defaults.padding.medium)
      .contentShape(Rectangle())
      .clipShape(Rectangle())
  }
}

#Preview {
  ZStack {
    Color.gray.ignoresSafeArea()
    
    VStack(spacing: Defaults.spacing.vertical.medium) {
      Button("Test"){}
        .buttonStyle(AppLabelButton())
    }
  }
}
