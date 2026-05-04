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
        .foregroundStyle(.white)
      
      Text(error.localizedDescription)
        .font(.callout)
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      Button {
        errorService.dismiss()
      } label: {
        Image(systemName: "xmark")
          .foregroundStyle(.white)
      }
    }
    .padding()
    .background(.red.opacity(0.95), in: .rect(cornerRadius: 12))
    .padding(.horizontal)
    .padding(.bottom, 8)
    .shadow(radius: 8)
  }
}
