//
//  MapView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 08/06/2026.
//

import SwiftUI
import MapKit

struct MapView: View {
  @Environment(PlacesViewModel.self) var vm

  var body: some View {
    @Bindable var vm = vm
    
    Map(position: $vm.cameraPosition) {
      UserAnnotation()
      
      ForEach(vm.placesNearby) { place in
        Annotation(place.name, coordinate: CLLocationCoordinate2D(
          latitude: place.latitude,
          longitude: place.longitude
        )) {
          ZStack {
            Circle()
              .frame(width: 34, height: 34)
              .foregroundStyle(Color.Text.Contrasted.primary)
            Circle()
              .frame(width: 28, height: 28)
              .foregroundStyle(Color.Button.primary)
            Image(systemName: place.categories.first?.iconName ?? "mappin.circle.fill")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .foregroundStyle(Color.Text.Contrasted.primary)
              .frame(width: 20, height: 20)
          }
          .onTapGesture { vm.displayPlace(place) }
        }
      }
    }
    .animation(.smooth(duration: 0.6), value: vm.cameraPosition)
  }
}

#Preview {
  MapView()
}
