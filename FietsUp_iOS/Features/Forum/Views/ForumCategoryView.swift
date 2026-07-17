//
//  ForumCategoryView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/05/2026.
//

import SwiftUI

struct ForumCategoryView: View {
  @Environment(ForumViewModel.self) private var vm
  let id: UUID

  var body: some View {
    @Bindable var vm = vm

    ScrollView {
      VStack(spacing: Defaults.spacing.vertical.large) {
        if vm.isLoading {
          ForEach(0..<5, id: \.self) { _ in
            ContentCard.forumPostPlaceholder
          }
          .redacted(reason: .placeholder)
          .shimmering()
        } else if vm.categoryMetadata.total == 0 {
          ContentUnavailableView(
            "forumCategory.empty.title",
            systemImage: "bubble.left.and.text.bubble.right",
            description: Text("forumCategory.empty.description")
          )
        } else if let posts = vm.category?.posts {
          ForEach(posts.items) { post in
            NavigationLink { ForumPostView(id: post.id).environment(vm) } label: {
              ContentCard(
                contentType: .forumPost,
                flairs: [CardFlair(name: post.user.nickname, iconName: "person.fill")],
                title: post.title,
                content: post.content,
                footerData: post.totalComments,
                date: post.lastActivityDate,
              )
            }
          }
        }
      }
      .padding()
      .frame(maxWidth: .infinity)
      
    }
    .background { Color.Surface.background.ignoresSafeArea() }
    .navigationTitle(vm.category?.name ?? String(localized: "common.loading"))
    .toolbarTitleDisplayMode(.inline)
    
    .appSheet(isPresented: $vm.isNewPostSheetPresented) {
      NavigationStack { NewPostSheet().environment(vm) }
    }
    
    .safeAreaInset(edge: .bottom) {
      PaginationBar(
        metadata: vm.categoryMetadata,
        onPrevious: { Task { await vm.goToCategoryPreviousPage() } },
        onNext: { Task { await vm.goToCategoryNextPage() } },
      )
    }
    
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button { vm.newPost() } label: {
          Label("forum.action.newPost", systemImage: "plus")
        }
      }
    }
    
    .task { await vm.loadCategory(id: id) }
    .refreshable { await vm.refreshCategory() }
  }
}

#Preview {
  NavigationStack {
    ForumCategoryView(id: UUID())
  }
}
