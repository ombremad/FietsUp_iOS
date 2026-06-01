//
//  SheetContainer.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 01/06/2026.
//

import SwiftUI

struct SheetContainer<Content: View>: View {
  let content: Content
  
  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }
  
  var body: some View {
    ZStack {
      content
      
      VStack {
        Spacer()
        ErrorOverlay()
      }
    }
  }
}

extension View {
  func appSheet<Content: View>(
    isPresented: Binding<Bool>,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View {
    self.sheet(isPresented: isPresented) {
      SheetContainer {
        content()
      }
    }
  }
}
