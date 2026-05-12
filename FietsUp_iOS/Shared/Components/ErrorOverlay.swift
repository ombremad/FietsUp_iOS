//
//  ErrorOverlay.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 04/05/2026.
//

import SwiftUI

struct ErrorOverlay: View {
  @State private var errorService = ErrorService.shared
  
  var body: some View {
    Group {
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
        .foregroundStyle(.white).opacity(0.9)
      
      Text(error.localizedDescription)
        .font(.callout)
        .foregroundStyle(.white).opacity(0.9)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      Button {
        errorService.dismiss()
      } label: {
        Image(systemName: "xmark")
          .foregroundStyle(.white).opacity(0.9)
      }
    }
    .padding()
    .background(Color.Surface.Error.primary)
    .cornerRadius(24)
    .padding(.horizontal)
    .padding(.bottom, 8)
    .shadow(radius: 8)
  }
}

extension View {
  func errorOverlay() -> some View {
    frame(maxWidth: .infinity, maxHeight: .infinity)
      .overlay(alignment: .bottom) { ErrorOverlay() }
  }
}

#Preview {
  ZStack {
    Color.gray.ignoresSafeArea()
      .errorOverlay()
      .task {
        ErrorService.shared.show(NSError(
          domain: "PreviewError",
          code: 1,
          userInfo: [NSLocalizedDescriptionKey: "This is a preview error message."]
        ))
      }
  }
}
