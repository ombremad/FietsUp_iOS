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
              onLike: {},
              onFav: {},
              onReport: {},
              onAnswer: {}
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
    ForumPostView(id: UUID(uuidString: "41F4ED05-39FA-43C0-9ABE-473C086105F0") ?? UUID())
  }
}
