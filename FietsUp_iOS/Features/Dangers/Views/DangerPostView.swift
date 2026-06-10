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
      }
      .frame(maxWidth: .infinity)

    }
    .background { Color.Surface.background.ignoresSafeArea() }
    .navigationTitle(vm.post?.title ?? "common.loading")
    .navigationBarTitleDisplayMode(.inline)
    
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
    if vm.isLoading {
      ContentComponent.bigPlaceholder
        .redacted(reason: .placeholder)
        .shimmering()
    } else {
      if let post = vm.post {
        ContentComponent(
          size: .big,
          title: post.title,
          content: post.content,
          date: post.creationDate!,
          user: post.user
        )
      }
    }
  }
}

#Preview {
  NavigationStack {
    DangerPostView(id: UUID())
  }
}
