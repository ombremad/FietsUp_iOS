//
//  NewPostSheet.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 01/06/2026.
//

import SwiftUI

struct NewPostSheet: View {
  @State private var vm = NewPostViewModel()
  @Environment(\.dismiss) private var dismiss

  let categoryId: UUID
  let categoryName: String

  var body: some View {
    Form {
      AppFormSection {
        VStack(alignment: .leading) {
          Text("post.inCategory")
            .font(.caption2)
          Text(categoryName)
        }
        .listRowBackground(Color.clear)
      }
      
      AppFormSection {
        TextField("post.title", text: $vm.newPostForm.title)
        TextField("post.content", text: $vm.newPostForm.content, axis: .vertical)
          .lineLimit(12)
      }
    }
    .listSectionSpacing(4)
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .navigationTitle("post.newPost")
    .navigationBarTitleDisplayMode(.inline)
    
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("common.confirm", systemImage: "arrow.up", role: .confirm) {
          Task {
            do {
              try await vm.submit()
              dismiss()
            } catch {
              ErrorService.shared.show(error)
            }
          }
        }.disabled(vm.isLoading)
      }
      ToolbarItem(placement: .cancellationAction) {
        Button("common.cancel", systemImage: "xmark", role: .cancel) { dismiss() }
      }
    }
    
    .task {
      vm.load(categoryId: categoryId)
    }
  }
}

#Preview {
  NavigationStack {
    NewPostSheet(categoryId: UUID(), categoryName: "Le coin des débutant·es")
  }
}
