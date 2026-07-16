//
//  DangerPostView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 09/06/2026.
//

import SwiftUI
import MapKit

struct DangerPostView: View {
  @Environment(DangersViewModel.self) private var vm
  @Environment(\.openURL) private var openURL
  let id: UUID
  
  var body: some View {
    @Bindable var vm = vm

    ScrollView {
      VStack(spacing: 42) {
        mapSnippet
        dangerDetails.padding(.horizontal)
        dangerComments.padding(.horizontal)
      }
      .padding(.bottom, 42)
      .frame(maxWidth: .infinity)

    }
    .ignoresSafeArea(.container, edges: .top)
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    
    .appSheet(isPresented: $vm.isNewCommentSheetPresented) {
      NavigationStack {
        NewDangerCommentSheet().environment(vm)
      }
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
  private var mapSnippet: some View {
    let height: CGFloat = 370
    let delta: Double = 0.001
    let offsetFactor: Double = -0.1

    if vm.isLoading {
      ProgressView().frame(height: height)
    } else {
      if let post = vm.post {
        VStack(spacing: 8) {
          Map(initialPosition: .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(
              latitude: post.latitude - delta * offsetFactor,
              longitude: post.longitude
            ),
            span: MKCoordinateSpan(
              latitudeDelta: delta,
              longitudeDelta: delta
            )
          ))) {
            Marker(post.title, coordinate: CLLocationCoordinate2D(
              latitude: post.latitude,
              longitude: post.longitude
            ))
            UserAnnotation()
          }
          .allowsHitTesting(false)
          
          Text("common.map.around \(vm.postApproximateLocation ?? "")")
            .font(.caption2)
            .foregroundStyle(Color.Text.secondary)
            .lineLimit(1)
            .padding(.horizontal)
        }
        .frame(height: height)
        .contentShape(Rectangle())
        .onTapGesture {
          if let url = URL(string: "https://maps.apple.com/?q=\(post.latitude),\(post.longitude)") {
            openURL(url)
          }
        }
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
            onLike: { Task { await vm.newFeedback(id: post.id, feedback: .like, content: .post) } },
            onFav: { Task { await vm.newFeedback(id: post.id, feedback: .fav, content: .post) } },
            onReport: { vm.newReport(id: post.id, contentType: .dangersPost, content: post.content) },
            onAnswer: { vm.newComment() },
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
                onReport: { vm.newReport(id: comment.id, contentType: .dangersComment, content: comment.content) },
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
    DangerPostView(id: UUID())
  }
}
