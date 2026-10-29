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
    List {
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
            Button { vm.edit(category) } label: {
              SimpleAdminPanelRow(
                title: category.name,
                description: category.details
              )
              .foregroundStyle(Color.Text.primary)
            }
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
        .presentationDetents([.fraction(0.4)])
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

#Preview {
  AdminForumCategoriesView()
}
