//
//  ForumView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 11/05/2026.
//

import SwiftUI

struct ForumView: View {
  @State private var vm = ForumViewModel()
  private let router = AppRouter.shared
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 24) {
        HStack {
          Text("forum.categories")
            .font(.title2)
            .foregroundStyle(Color.Text.secondary)
          Spacer()
        }
        
        if vm.isLoading  {
          ProgressView()
        } else {
          ForEach(vm.categories) { category in
            ContentCard(category)
              .onTapGesture {
                router.push(ForumDestination.category(id: category.id))
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
    .navigationTitle("forum.title")
    .navigationBarTitleDisplayMode(.large)
    
    .navigationDestination(for: ForumDestination.self) { destination in
      switch destination {
        case .category(let id): ForumCategoryView(id: id)
        case .post(let id): ForumPostView(id: id)
      }
    }
    
    .task {
      await vm.load()
    }
  }
}

#Preview {
  NavigationStack {
    ForumView()
  }
}
