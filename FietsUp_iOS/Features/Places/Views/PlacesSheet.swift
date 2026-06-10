//
//  PlacesSheet.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 03/06/2026.
//

import SwiftUI

struct PlacesSheet: View {
  @Environment(PlacesViewModel.self) var vm
  @State private var selectedDetent: PresentationDetent = .medium

  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        placesList
      }
      .padding(.vertical, 24)
      .padding(.horizontal)
    }
    .foregroundStyle(Color.Text.primary)
    
    .presentationDetents([.fraction(0.10), .medium, .large], selection: $selectedDetent)
    .presentationDragIndicator(.visible)
    .interactiveDismissDisabled()
    .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.10)))
    .presentationBackground {
      if selectedDetent == .large {
        Color.Surface.background
      } else {
        Color.clear
      }
    }
    
    .navigationTitle("places.placesNearby")
    .navigationBarTitleDisplayMode(.inline)
    
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button("common.cancel", systemImage: "xmark", role: .cancel) {
          vm.closeAllSheets()
        }
      }
    }
  }
  
  private var placesList: some View {
    VStack(spacing: 16) {
      if vm.placesNearby.isEmpty {
        ForEach(0..<3, id: \.self) { _ in
          ContentCard.placePlaceholder
            .redacted(reason: .placeholder)
            .shimmering()
        }
      } else {
        ForEach(vm.placesNearby) { place in
          ContentCard(
            contentType: .place,
            flairs: place.categories.map {
              CardFlair(
                name: $0.name,
                iconName: $0.iconName
              )
            },
            title: place.name,
            content: place.otherDetails,
            footerData: distanceBetweenTwoPoints(
              lat1: vm.latitude ?? 0,
              lon1: vm.longitude ?? 0,
              lat2: place.latitude,
              lon2: place.longitude
            )
          )
          .onTapGesture {
            vm.displayPlace(place)
          }
        }
      }
    }
  }
}
