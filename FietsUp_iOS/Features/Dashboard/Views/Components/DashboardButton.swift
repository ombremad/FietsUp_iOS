//
//  DashboardButton.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 12/05/2026.
//

import SwiftUI

struct DashboardButton: View {
  var label: String
  var iconName: String
  var role: DashButtonRole = .primary
  var action: () -> Void

  enum DashButtonRole {
    case primary, neutral
  }
  
  private var backgroundColor: Color {
    switch role {
      case .primary: Color.Button.primary
      case .neutral: Color.Button.neutral
    }
  }
  
  private var foregroundColor: Color {
    switch role {
      case .primary: Color.Text.Contrasted.primary
      case .neutral: Color.Text.Contrasted.tertiary
    }
  }

  var body: some View {
    Button(action: action) {
      VStack(spacing: 8) {
        Image(systemName: iconName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 48, height: 36)
        Text(label)
          .font(.caption)
          .lineLimit(1)
      }
      .padding()
      .frame(height: 105)
      .frame(maxWidth: .infinity)
      .foregroundStyle(foregroundColor)
      .background(backgroundColor)
      .clipShape(RoundedRectangle(cornerRadius: 18))
    }
  }
}

#Preview {
  HStack {
    DashboardButton(
      label: "Preview",
      iconName: "chart.bar.xaxis.ascending.badge.clock",
      role: .neutral
    ) {}
    Spacer()
    DashboardButton(
      label: "Add",
      iconName: "plus.circle",
      role: .primary
    ) {}
  }
}
