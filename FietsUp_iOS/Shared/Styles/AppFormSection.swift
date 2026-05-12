//
//  AppFormSection.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 11/05/2026.
//

import SwiftUI

struct AppFormSection<Content: View>: View {
  let header: LocalizedStringKey?
  @ViewBuilder var content: () -> Content
  
  init(_ header: LocalizedStringKey? = nil, @ViewBuilder content: @escaping () -> Content) {
    self.header = header
    self.content = content
  }
  
  var body: some View {
    Section {
      content()
    } header: {
      if let header { Text(header) }
    }
    .listRowBackground(Color.Surface.field)
    .listRowSeparatorTint(Color.Surface.divider)
    .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
  }
}
