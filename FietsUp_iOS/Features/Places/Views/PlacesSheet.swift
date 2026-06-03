//
//  PlacesSheet.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 03/06/2026.
//

import SwiftUI

struct PlacesSheet: View {
  @Environment(PlacesViewModel.self) var vm
  
  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        headerSection
        testSection
        // placesList
      }
      .padding(.vertical, 24)
      .padding(.horizontal)
    }
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .presentationDetents([.medium, .large])
    .presentationDragIndicator(.visible)
  }
  
  private var headerSection: some View {
    HStack {
      Text("places.nearby")
        .font(.title2)
        .foregroundStyle(Color.Text.secondary)
      Spacer()
    }
  }
  
  @ViewBuilder
  private var testSection: some View {
    if let latitude = vm.latitude, let longitude = vm.longitude {
      HStack {
        Text("Latitude:")
        Spacer()
        Text(latitude.description)
      }
      HStack {
        Text("Longitude:")
        Spacer()
        Text(longitude.description)
      }
    }
  }
  
  private var placesList: some View {
    VStack(spacing: 16) {
      Text("ici")
      Text("là")
    }
  }
}

#Preview {
  NavigationStack {
    PlacesSheet()
  }
}
