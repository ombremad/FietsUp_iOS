//
//  AdminDangerCategoriesView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 17/07/2026.
//

import SwiftUI

struct AdminDangerCategoriesView: View {
  @State private var vm = AdminDangerCategoriesViewModel()
  
  var body: some View {
    List {
      AppFormSection {
        if vm.isLoading {
          ForEach(0..<3, id: \.self) { _ in
            SimpleAdminPanelRow(
              title: Placeholder.DangerCategory.name,
              iconName: Placeholder.DangerCategory.iconName,
            )
          }
          .redacted(reason: .placeholder)
          .shimmering()
        } else {
          ForEach(vm.categories, id: \.id) { place in
            SimpleAdminPanelRow(
              title: place.name,
              iconName: place.iconName,
            )
            .onTapGesture { vm.edit(place) }
          }
        }
      }
    }
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .scrollContentBackground(.hidden)
    .navigationTitle("admin.dangerCategories.title")
    .toolbarTitleDisplayMode(.inline)
    
    .appSheet(isPresented: $vm.isSingleCategorySheetPresented) {
      NavigationStack { AdminDangerCategorySheet().environment(vm) }
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
      Task { try await vm.refreshCategories() }
    }
  }
}
