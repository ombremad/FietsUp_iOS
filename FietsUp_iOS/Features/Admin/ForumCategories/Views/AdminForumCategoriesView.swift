//
//  AdminForumCategoriesView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 06/07/2026.
//

import SwiftUI

struct AdminForumCategoriesView: View {
  @State private var vm = AdminForumCategoriesViewModel()
  
  var body: some View {
    Form {
      AppFormSection {
        if vm.isLoading {
          ForEach(0..<3, id: \.self) { _ in
            SimpleAdminPanelRow(
              title: Placeholder.ForumCategory.name,
              description: Placeholder.ForumCategory.content,
            )
          }
          .redacted(reason: .placeholder)
          .shimmering()
        } else {
          ForEach(vm.categories, id: \.id) { category in
            SimpleAdminPanelRow(
              title: category.name,
              description: category.details
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
    .navigationTitle("admin.forumCategories.title")
    .toolbarTitleDisplayMode(.inline)
    
    .appSheet(isPresented: $vm.isSingleCategorySheetPresented) {
      NavigationStack { AdminForumCategorySheet().environment(vm) }
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

#Preview {
  AdminForumCategoriesView()
}
