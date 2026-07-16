//
//  DangersView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 11/05/2026.
//

import SwiftUI

struct DangersView: View {
  @State private var vm = DangersViewModel()

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: Defaults.spacing.vertical.large) {
        HStack {
          Text("dangers.dangersNearby")
            .font(.title2)
            .foregroundStyle(Color.Text.secondary)
          Spacer()
        }
        
        if vm.isLoading  {
          ForEach(0..<5, id: \.self) { _ in
            ContentCard.dangerPostPlaceholder
          }
          .redacted(reason: .placeholder)
          .shimmering()
        } else if vm.posts.isEmpty {
          ContentUnavailableView(
            "dangers.empty.title",
            systemImage: "bubble.left.and.exclamationmark.bubble.right",
            description: Text("dangers.empty.description")
          )
        } else {
          ForEach(vm.posts) { post in
            NavigationLink { DangerPostView(id: post.id).environment(vm) } label: {
              ContentCard(
                contentType: .dangerPost,
                flairs: [CardFlair(
                  name: post.dangerCategory.name,
                  iconName: post.dangerCategory.iconName
                )],
                title: post.title,
                content: post.content,
                footerData: distanceBetweenTwoPoints(
                  lat1: vm.latitude ?? 0,
                  lon1: vm.longitude ?? 0,
                  lat2: post.latitude,
                  lon2: post.longitude
                ),
                date: post.creationDate
              )
            }
          }
        }
      }
      .padding()
      .frame(maxWidth: .infinity)

    }
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .scrollContentBackground(.hidden)
    .navigationTitle("dangers.title")
    .navigationBarTitleDisplayMode(.large)
    
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button { vm.newPost() } label: {
          Label("dangers.action.newPost", systemImage: "plus")
        }
      }
    }
    
    .appSheet(isPresented: $vm.isNewPostSheetPresented) {
      NavigationStack {
        NewDangerPostSheet().environment(vm)
      }
    }
    
    .task {
      await vm.loadPosts()
      await vm.loadCategories()
    }
    .refreshable { await vm.refreshPosts() }
  }
}

#Preview {
  DangersView()
}
