//
//  DangerPostView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 09/06/2026.
//

import SwiftUI
import MapKit

struct DangerPostView: View {
  @State private var vm = DangerPostViewModel()
  let id: UUID
  
  var body: some View {
    ScrollView {
      VStack(spacing: 42) {
        mapSnippet
        dangerDetails.padding(.horizontal)
        dangerComments.padding(.horizontal)
      }
      .padding(.bottom, 42)
      .frame(maxWidth: .infinity)

    }
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .navigationTitle(vm.post?.title ?? "common.loading")
    .navigationBarTitleDisplayMode(.inline)
    
    .appSheet(isPresented: $vm.isNewCommentSheetPresented) {
      NavigationStack {
        NewDangerCommentSheet(onSuccess: {
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
  private var mapSnippet: some View {
    if vm.isLoading {
      ProgressView().frame(height: 220)
    } else {
      if let post = vm.post {
        Map(initialPosition: .region(MKCoordinateRegion(
          center: CLLocationCoordinate2D(latitude: post.latitude, longitude: post.longitude),
          span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))) {
          Marker(post.title, coordinate: CLLocationCoordinate2D(
            latitude: post.latitude,
            longitude: post.longitude
          ))
        }
        .frame(height: 220)
        .disabled(true)
      }
    }
  }
  
  @ViewBuilder
  private var dangerDetails: some View {
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
            onReport: { vm.report(.dangersPost, content: post.content, id: post.id) },
            onAnswer: { vm.isNewCommentSheetPresented.toggle() },
            isLoading: vm.isFeedbackLoading
          )
        }
      }
    }
  }
  
  @ViewBuilder
  private var dangerComments: some View {
    VStack(spacing: 24) {
      if vm.isLoading {
        Group {
          ForEach(0..<5, id: \.self) { _ in
            ContentComponent.smallPlaceholder
            ButtonBar.placeholder
          }
        }
        .redacted(reason: .placeholder)
        .shimmering()
      } else {
        if let post = vm.post {
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
              ButtonBar(
                likeCount: comment.likeCount,
                isLiked: comment.likedByUser,
                isFaved: comment.favedByUser,
                onLike: { Task { await vm.feedback(feedback: .like, content: .comment, id: comment.id) }},
                onFav: { Task { await vm.feedback(feedback: .fav, content: .comment, id: comment.id) }},
                onReport: { vm.report(.dangersComment, content: comment.content, id: comment.id) },
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
    DangerPostView(id: UUID())
  }
}
