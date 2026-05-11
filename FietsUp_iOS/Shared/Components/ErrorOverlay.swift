//
//  ErrorOverlay.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 04/05/2026.
//

import SwiftUI

import SwiftUI

struct ErrorOverlay: View {
  @State private var errorService = ErrorService.shared
  
  var body: some View {
    VStack {
      Spacer()
      if let error = errorService.currentError {
        bannerContent(for: error)
          .transition(.move(edge: .bottom).combined(with: .opacity))
      }
    }
    .animation(.spring(duration: 0.3), value: errorService.currentError?.localizedDescription)
    .allowsHitTesting(errorService.currentError != nil)
  }
  
  @ViewBuilder
  private func bannerContent(for error: any Error) -> some View {
    HStack(alignment: .top, spacing: 12) {
      Image(systemName: "exclamationmark.triangle.fill")
        .foregroundStyle(Color.Text.Contrasted.primary)
      
      Text(error.localizedDescription)
        .font(.caption)
        .foregroundStyle(Color.Text.Contrasted.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      Button {
        errorService.dismiss()
      } label: {
        Image(systemName: "xmark")
          .foregroundStyle(Color.Text.Contrasted.primary)
      }
    }
    .padding()
    .background(Color.Error.primary)
    .padding(.horizontal)
    .padding(.bottom, 8)
    .shadow(radius: 8)
  }
}
