//
//  AdminPlaceCategoriesView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 10/07/2026.
//

import SwiftUI

struct AdminPlaceCategoriesView: View {
  @State private var vm = AdminPlaceCategoriesViewModel()
  
  var body: some View {
    Form {
      AppFormSection {
        if vm.isLoading {
          ForEach(0..<3, id: \.self) { _ in
            SimpleAdminPanelRow(
              title: Placeholder.PlaceCategory.name,
              iconName: Placeholder.PlaceCategory.iconName
            )
          }
          .redacted(reason: .placeholder)
          .shimmering()
        } else {
          ForEach(vm.categories, id: \.id) { category in
            SimpleAdminPanelRow(
              title: category.name,
              iconName: category.iconName
            ).onTapGesture { vm.edit(category) }
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
    .navigationTitle("admin.placeCategories.title")
    .toolbarTitleDisplayMode(.inline)
    
    .appSheet(isPresented: $vm.isSingleCategorySheetPresented) {
      NavigationStack { AdminPlaceCategorySheet().environment(vm) }
    }
    
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button { vm.create() } label: {
          Label("admin.placeCategories.create", systemImage: "plus")
        }
      }
    }
    
    .task { await vm.load() }
    .refreshable {
      Task { try await vm.refreshCategories() }
    }
  }
}
