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
          ForEach(vm.categories, id: \.id) { category in
            Button { vm.edit(category) } label: {
              SimpleAdminPanelRow(
                title: category.name,
                iconName: category.iconName,
              )
              .foregroundStyle(Color.Text.primary)
            }
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
        .presentationDetents([.fraction(0.4)])
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
      do {
        try await vm.refreshCategories()
      } catch {
        ErrorService.shared.show(error)
      }
    }
  }
}
