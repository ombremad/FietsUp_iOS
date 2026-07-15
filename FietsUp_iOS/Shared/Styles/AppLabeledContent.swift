//
//  AppLabeledContent.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/07/2026.
//

import SwiftUI

struct AppLabeledContent: LabeledContentStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack(alignment: .top) {
      configuration.label
        .foregroundStyle(Color.Text.secondary)
      Spacer()
      configuration.content
        .foregroundStyle(Color.Text.primary)
        .multilineTextAlignment(.trailing)
    }
    .font(.body)
  }
}
