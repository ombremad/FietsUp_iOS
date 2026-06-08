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
      VStack(spacing: 42) {
        if vm.isLoading {
          Group {
            ContentComponent.bigPlaceholder
            ForEach(0..<5, id: \.self) { _ in
              ContentComponent.smallPlaceholder
            }
          }
          .redacted(reason: .placeholder)
          .shimmering()
        } else {
          if let post = vm.post {
            ContentComponent(
              size: .big,
              title: post.title,
              content: post.content,
              date: post.creationDate,
              user: post.user
            )
            if post.comments.isEmpty {
              Rectangle()
                .foregroundStyle(Color.Surface.divider)
                .frame(height: 1)
              ContentUnavailableView(
                "comments.empty.title",
                systemImage: "bubble.left.and.text.bubble.right",
                description: Text("comments.empty.description")
              )
            } else {
              ForEach(post.comments) { comment in
                Rectangle()
                  .foregroundStyle(Color.Surface.divider)
                  .frame(height: 1)
                ContentComponent(
                  size: .small,
                  content: comment.content,
                  date: comment.creationDate,
                  user: comment.user
                )
              }
            }
          }
        }
      }
      .padding()
      .frame(maxWidth: .infinity)
      
    }
    .background { Color.Surface.background.ignoresSafeArea() }
        
    .appSheet(isPresented: $vm.isNewCommentSheetPresented) {
      NavigationStack {
        NewCommentSheet(postId: id, postName: vm.post?.title ?? "")
          .presentationDetents([.medium, .large])
      }
    }

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
