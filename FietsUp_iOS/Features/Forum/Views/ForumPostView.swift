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
      NavigationStack {
        NewCommentSheet(onSuccess: {
          Task { await vm.load(id: id) }
        }, postId: id, postName: vm.post?.title ?? "")
      }
    }
    
    .appSheet(item: $vm.reportTarget) { target in
      NavigationStack {
        NewReportSheet(id: target.id, contentType: target.contentType, content: target.content)
      }
    }

    .refreshable {
      await vm.load(id: id)
    }
    .task {
      await vm.load(id: id)
    }
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
            onLike: { Task { await vm.feedback(feedback: .like, content: .post, id: post.id) } },
            onFav: { Task { await vm.feedback(feedback: .fav, content: .post, id: post.id) } },
            onReport: { vm.report(contentType: .forumPost, content: post.content, id: post.id) },
            onAnswer: { vm.isNewCommentSheetPresented.toggle() },
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
                onLike: { Task { await vm.feedback(feedback: .like, content: .comment, id: comment.id) } },
                onFav: { Task { await vm.feedback(feedback: .fav, content: .comment, id: comment.id) } },
                onReport: { vm.report(contentType: .forumComment, content: comment.content, id: comment.id) },
                onAnswer: { vm.isNewCommentSheetPresented.toggle() },
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
