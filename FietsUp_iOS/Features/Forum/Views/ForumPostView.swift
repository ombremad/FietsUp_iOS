//
//  ForumPostView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 17/05/2026.
//

import SwiftUI

struct ForumPostView: View {
  @State private var vm = ForumPostViewModel()
  let id: UUID

  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        if vm.isLoading {
          ProgressView()
        } else {
          if let post = vm.post {
            ForumPostComponent(
              post: post,
              onLike: { Task { await vm.like() } },
              onFav: { Task { await vm.fav() } },
              onReport: {},
              onAnswer: {},
              isLiking: vm.isLiking,
              isFaving: vm.isFaving,
            )
          }
        }
      }
      .padding()
      .frame(maxWidth: .infinity)
      
    }
    .background { Color.Surface.background.ignoresSafeArea() }
    .navigationTitle(vm.post?.title ?? String(localized: "common.loading"))
    .toolbarTitleDisplayMode(.inline)
    
    .task {
      await vm.load(id: id)
    }
  }
}

#Preview {
  NavigationStack {
    ForumPostView(id: UUID())
  }
}
