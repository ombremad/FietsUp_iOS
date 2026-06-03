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
    VStack {
      Text("PlacesView")
    }
      .foregroundStyle(Color.Text.primary)
      .background { Color.Surface.background.ignoresSafeArea() }
      .scrollContentBackground(.hidden)
      .navigationTitle("places.title")
      .navigationBarTitleDisplayMode(.inline)
    
      .appSheet(isPresented: $vm.isSinglePlaceSheetPresented) {
        SinglePlaceSheet().environment(vm)
      }
      .appSheet(isPresented: $vm.isPlacesSheetPresented) {
        PlacesSheet().environment(vm)
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
