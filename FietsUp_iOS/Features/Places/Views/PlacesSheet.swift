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
        placesList
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
    
  private var placesList: some View {
    VStack(spacing: 16) {
      if vm.placesNearby.isEmpty {
        Text("empty")
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
