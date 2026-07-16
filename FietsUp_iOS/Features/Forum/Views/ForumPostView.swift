//
//  ForumPostView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 17/05/2026.
//

import SwiftUI

struct ForumPostView: View {
  @Environment(ForumViewModel.self) private var vm
  let id: UUID

  var body: some View {
    @Bindable var vm = vm

    ScrollView {
      VStack(spacing: 42) {
        postDetails
        postComments
      }
      .padding()
      .padding(.bottom, 42)
      .frame(maxWidth: .infinity)
      
    }
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
        
    .appSheet(isPresented: $vm.isNewCommentSheetPresented) {
      NavigationStack { NewCommentSheet().environment(vm) }
    }
    
    .appSheet(item: $vm.newReportTarget) { target in
      NavigationStack {
        NewReportSheet(id: target.id, contentType: target.contentType, content: target.content)
      }
    }

    .task { await vm.loadPost(id: id) }
    .refreshable { await vm.refreshPost() }
  }
  
  @ViewBuilder
  private var postDetails: some View {
    VStack(spacing: 24) {
      if vm.isLoading {
        Group {
          ContentComponent.bigPlaceholder
          ButtonBar.placeholder
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
          ButtonBar(
            likeCount: post.likeCount,
            isLiked: post.likedByUser,
            isFaved: post.favedByUser,
            onLike: { Task { await vm.newFeedback(id: post.id, feedback: .like, content: .post) } },
            onFav: { Task { await vm.newFeedback(id: post.id, feedback: .fav, content: .post) } },
            onReport: { vm.newReport(id: post.id, contentType: .forumPost, content: post.content) },
            onAnswer: { vm.newComment() },
            isLoading: vm.isFeedbackLoading
          )
        }
      }
    }
  }
  
  @ViewBuilder
  private var postComments: some View {
    VStack(spacing: 24) {
      if vm.isLoading {
        Group {
          ForEach(0..<5, id: \.self) { _ in
            Divider()
            ContentComponent.smallPlaceholder
            ButtonBar.placeholder
          }
        }
        .redacted(reason: .placeholder)
        .shimmering()
      } else {
        if let post = vm.post {
          if post.comments.isEmpty {
            Divider()
            ContentUnavailableView(
              "comments.empty.title",
              systemImage: "bubble.left.and.text.bubble.right",
              description: Text("comments.empty.description")
            )
          } else {
            ForEach(post.comments) { comment in
              Divider()
              ContentComponent(
                size: .small,
                content: comment.content,
                date: comment.creationDate,
                user: comment.user
              )
              ButtonBar(
                likeCount: comment.likeCount,
                isLiked: comment.likedByUser,
                isFaved: comment.favedByUser,
                onLike: { Task { await vm.newFeedback(id: comment.id, feedback: .like, content: .comment) } },
                onFav: { Task { await vm.newFeedback(id: comment.id, feedback: .fav, content: .comment) } },
                onReport: { vm.newReport(id: comment.id, contentType: .forumComment, content: comment.content) },
                onAnswer: { vm.newComment() },
                isLoading: vm.isFeedbackLoading
              )
            }
          }
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    ForumPostView(id: UUID())
  }
}
