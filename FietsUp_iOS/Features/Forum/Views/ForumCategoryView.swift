//
//  ForumCategoryView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/05/2026.
//

import SwiftUI

struct ForumCategoryView: View {
  @State private var vm = ForumCategoryViewModel()
  private let router = AppRouter.shared

  let id: UUID
  
  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        if vm.isLoading {
          ProgressView()
        } else {
          if let category = vm.category {
            ForEach(category.posts) { post in
              ContentCard(post)
                .onTapGesture {
                  router.push(ForumDestination.post(id: post.id))
                }
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
      NavigationStack {
        NewPostSheet(categoryId: id, categoryName: vm.category?.name ?? "")
          .presentationDetents([.medium, .large])
      }
    }
    
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button {
          vm.isNewPostSheetPresented.toggle()
        } label: {
          Label("forum.action.newPost", systemImage: "plus")
        }
      }
    }
    
    .task {
      await vm.load(id: id)
    }
  }
}

#Preview {
  NavigationStack {
    ForumCategoryView(id: UUID(uuidString: "353F16AB-6899-4E2E-9EE2-BB4E913F6922") ?? UUID())
  }
}
