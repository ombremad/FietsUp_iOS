//
//  AdminPlacesView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/07/2026.
//

import SwiftUI

struct AdminPlacesView: View {
  @State private var vm = AdminPlacesViewModel()
  
  var body: some View {
    List {
      AppFormSection {
        if vm.isLoading {
          ForEach(0..<3, id: \.self) { _ in
            SimpleAdminPanelRow(title: Placeholder.Place.name)
          }
          .redacted(reason: .placeholder)
          .shimmering()
        } else {
          ForEach(vm.places, id: \.id) { place in
            SimpleAdminPanelRow(title: place.name)
              .onTapGesture { vm.edit(place) }
          }
          .onDelete { offsets in
            Task { await vm.delete(at: offsets) }
          }
        }
      }
    }
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .scrollContentBackground(.hidden)
    .navigationTitle("admin.places.title")
    .toolbarTitleDisplayMode(.inline)
    
    .appSheet(isPresented: $vm.isSinglePlaceSheetPresented) {
      NavigationStack { AdminPlaceSheet().environment(vm) }
    }
    
    .safeAreaInset(edge: .bottom) {
      PaginationBar(
        metadata: vm.metadata,
        onPrevious: { Task { await vm.goToPreviousPage() } },
        onNext: { Task { await vm.goToNextPage() } },
      )
    }
    
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button { vm.create() } label: {
          Label("common.create", systemImage: "plus")
        }
      }
    }
  
    .task { await vm.load() }
    .refreshable {
      Task { try await vm.refreshPlaces() }
    }
  }
}
