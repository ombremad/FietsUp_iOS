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
      .toolbar(vm.hasActiveSheet ? .hidden : .visible, for: .tabBar)
    
      .toolbar {
        if !vm.hasActiveSheet {
          ToolbarItem(placement: .primaryAction) {
            Button("places.showPlaces", systemImage: "map") {
              vm.showPlacesSheet()
            }
            .opacity(vm.hasActiveSheet ? 0 : 1)
            .scaleEffect(vm.hasActiveSheet ? 0.7 : 1)
            .allowsHitTesting(!vm.hasActiveSheet)
            .animation(.easeInOut(duration: 0.4), value: vm.hasActiveSheet)
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
