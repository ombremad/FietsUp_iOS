//
//  AppButtonSection.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 11/05/2026.
//

import SwiftUI

struct AppButtonSection<Content: View>: View {
  let header: LocalizedStringKey?
  @ViewBuilder var content: () -> Content
  
  init(_ header: LocalizedStringKey? = nil, @ViewBuilder content: @escaping () -> Content) {
    self.header = header
    self.content = content
  }
  
  var body: some View {
    Section {
      VStack(spacing: 0) {
        content()
      }
      .frame(maxWidth: .infinity)
    } header: {
      if let header { Text(header) }
    }
    .listRowBackground(Color.clear)
    .listRowSeparator(.hidden)
    .listRowInsets(EdgeInsets())
  }
}
