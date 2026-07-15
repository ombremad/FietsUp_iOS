//
//  AdminModerationCategoriesView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/07/2026.
//

import SwiftUI

struct AdminModerationCategoriesView: View {
  @State private var vm = AdminModerationCategoriesViewModel()
  
  var body: some View {
    List {
      AppFormSection {
        if vm.isLoading {
          ForEach(0..<3, id: \.self) { _ in
            Text(Placeholder.ModerationCategory.name)
              .font(.body)
          }
          .redacted(reason: .placeholder)
          .shimmering()
        } else {
          ForEach(vm.categories, id: \.id) { category in
            Text(category.name)
              .onTapGesture { vm.edit(category) }
          }
        }
      }
    }
    
    .font(.body)
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .scrollContentBackground(.hidden)
    .navigationTitle("admin.moderationCategories.title")
    .toolbarTitleDisplayMode(.inline)
    
    .appSheet(isPresented: $vm.isSingleCategorySheetPresented) {
      NavigationStack { AdminModerationCategorySheet().environment(vm) }
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
