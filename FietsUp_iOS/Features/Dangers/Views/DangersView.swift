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
          ProgressView()
        } else {
          ForEach(vm.dangerPosts) { danger in
            ContentCard(
              contentType: .dangerPost,
              title: danger.title,
              content: danger.content,
              footerData: danger.totalComments,
              date: danger.creationDate
            )
            .onTapGesture {
              // TODO: this
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
    
    .task {
      await vm.load()
    }
  }
}

#Preview {
  DangersView()
}
