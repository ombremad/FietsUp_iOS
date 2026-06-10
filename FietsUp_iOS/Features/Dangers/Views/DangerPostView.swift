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
  @Environment(\.openURL) private var openURL

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
      ProgressView().frame(height: 235)
    } else {
      if let post = vm.post {
        VStack(spacing: 0) {
          Map(initialPosition: .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: post.latitude, longitude: post.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
          ))) {
            Marker(post.title, coordinate: CLLocationCoordinate2D(
              latitude: post.latitude,
              longitude: post.longitude
            ))
            UserAnnotation()
          }
          .allowsHitTesting(false)
          
          Spacer()
          
          Text("common.map.around \(vm.approximateLocation ?? "")")
            .font(.caption2)
            .foregroundStyle(Color.Text.secondary)
            .lineLimit(1)
            .padding(.horizontal)
        }
        .frame(height: 235)
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
            onLike: { Task { await vm.feedback(feedback: .like, content: .post, id: post.id) } },
            onFav: { Task { await vm.feedback(feedback: .fav, content: .post, id: post.id) } },
            onReport: { vm.report(contentType: .dangersPost, content: post.content, id: post.id) },
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
                onLike: { Task { await vm.feedback(feedback: .like, content: .comment, id: comment.id) }},
                onFav: { Task { await vm.feedback(feedback: .fav, content: .comment, id: comment.id) }},
                onReport: { vm.report(contentType: .dangersComment, content: comment.content, id: comment.id) },
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
