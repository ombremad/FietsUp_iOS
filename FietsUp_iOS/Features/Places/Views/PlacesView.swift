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
        ToolbarItem(placement: .primaryAction) {
          Button("places.showMe", systemImage: "location") {
            vm.centerOnUser()
          }
        }
        ToolbarItem(placement: .primaryAction) {
          Button("places.showPlaces", systemImage: "list.bullet") {
            vm.showPlacesSheet()
          }.disabled(vm.hasActiveSheet)
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
