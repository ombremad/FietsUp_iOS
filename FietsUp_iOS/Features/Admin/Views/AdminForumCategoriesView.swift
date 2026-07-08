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
            ForumCategoryRowCard.placeholder
          }
          .redacted(reason: .placeholder)
          .shimmering()
        } else {
          ForEach(vm.categories, id: \.id) { category in
            ForumCategoryRowCard(category)
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
    .navigationTitle("admin.forumPanel.forumCategories")
    .toolbarTitleDisplayMode(.inline)
    
    .task {
      await vm.load()
    }
    .refreshable {
      Task { try await vm.refreshCategories() }
    }
  }
}

#Preview {
  AdminForumCategoriesView()
}
