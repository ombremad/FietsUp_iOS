//
//  DangersView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 11/05/2026.
//

import SwiftUI

struct DangersView: View {
  @State private var vm = DangersViewModel()
  private let router = AppRouter.shared

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 24) {
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
        } else if vm.dangerPosts.isEmpty {
          ContentUnavailableView(
            "dangers.empty.title",
            systemImage: "bubble.left.and.exclamationmark.bubble.right",
            description: Text("dangers.empty.description")
          )
        } else {
          ForEach(vm.dangerPosts) { danger in
            ContentCard(
              contentType: .dangerPost,
              flairs: [CardFlair(
                name: danger.dangerCategory.name,
                iconName: danger.dangerCategory.iconName
              )],
              title: danger.title,
              content: danger.content,
              footerData: distanceBetweenTwoPoints(
                lat1: vm.latitude ?? 0,
                lon1: vm.longitude ?? 0,
                lat2: danger.latitude,
                lon2: danger.longitude
              ),
              date: danger.creationDate
            )
            .onTapGesture {
              router.push(DangersDestination.post(id: danger.id))
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
        Button {
          vm.isNewDangerPostSheetPresented.toggle()
        } label: {
          Label("dangers.action.newPost", systemImage: "plus")
        }
      }
    }
    
    .appSheet(isPresented: $vm.isNewDangerPostSheetPresented) {
      NavigationStack {
        NewDangerPostSheet(onSuccess: {
          Task { await vm.load() }
        })
      }
    }
    
    .navigationDestination(for: DangersDestination.self) { destination in
      switch destination {
        case .post(let id): DangerPostView(id: id)
      }
    }

    .refreshable {
      await vm.load()
    }
    .task {
      guard vm.dangerPosts.isEmpty else { return }
      await vm.load()
    }
  }
}

#Preview {
  DangersView()
}
