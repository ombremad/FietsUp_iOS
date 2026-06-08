//
//  PlacesView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 11/05/2026.
//

import SwiftUI

struct PlacesView: View {
  @State private var vm = PlacesViewModel()
  
  var body: some View {
    ZStack {
      MapView().environment(vm)
    }
      .foregroundStyle(Color.Text.primary)
      .background { Color.Surface.background.ignoresSafeArea() }
      .scrollContentBackground(.hidden)
    
      .toolbar {
        if (vm.isSinglePlaceSheetPresented == false && vm.isPlacesSheetPresented == false) {
          ToolbarItem(placement: .primaryAction) {
            let isVisible = !vm.isSinglePlaceSheetPresented && !vm.isPlacesSheetPresented

            Button("places.showPlaces", systemImage: "map") {
              vm.showPlacesSheet()
            }
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : 0.7)
            .allowsHitTesting(isVisible)
            .animation(.easeInOut(duration: 0.4), value: isVisible)

          }
        }
      }
    
      .appSheet(isPresented: $vm.isSinglePlaceSheetPresented) {
        NavigationStack {
          SinglePlaceSheet().environment(vm)
        }
      }
      .appSheet(isPresented: $vm.isPlacesSheetPresented) {
        NavigationStack {
          PlacesSheet().environment(vm)
        }
      }
    
      .task {
        await vm.load()
      }
      .task(id: vm.hasLocation) {
        await vm.performFetchPlaces()
      }
  }
}

#Preview {
  PlacesView()
}
