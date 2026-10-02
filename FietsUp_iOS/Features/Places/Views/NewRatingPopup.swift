//
//  NewRatingSheet.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 18/09/2026.
//

import SwiftUI

struct NewRatingPopup: View {
  @Environment(PlacesViewModel.self) private var vm
  @Binding var isVisible: Bool
    
  private var content: some View {
    HStack(spacing: Defaults.spacing.horizontal.medium) {
      ForEach(1...5, id:\.self) { note in
        Button {
          Task {
            do {
              try await vm.ratePlace(note)
              withAnimation(.snappy) { isVisible.toggle() }
            } catch {
              ErrorService.shared.show(error)
            }
          }
        } label: {
          Image(systemName: "star")
        }
      }
    }
    .font(.system(size: 32))
    .foregroundStyle(.yellow)
    .padding(.horizontal, Defaults.padding.xlarge)
    .padding(.vertical, Defaults.padding.medium)
    .background(Color.Surface.primary)
    .clipShape(Capsule())
  }
  
  var body: some View {
    ZStack {
      if isVisible {
        Color.Surface.tertiary.opacity(0.92).ignoresSafeArea()
          .onTapGesture {
            withAnimation(.snappy) { isVisible.toggle() }
          }
          .transition(.opacity)
      }
      
      if isVisible {
        HStack {
          Spacer()
          VStack {
            Spacer()
            content
            Spacer()
          }
          Spacer()
        }
        .transition(.asymmetric(
          insertion: .move(edge: .bottom),
          removal: .opacity
        ))
      }
    }
  }
}
