//
//  NewCommentSheet.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 02/06/2026.
//

import SwiftUI

struct NewCommentSheet: View {
  @State private var vm = NewCommentViewModel()
  @Environment(\.dismiss) private var dismiss
  
  let postId: UUID
  let postName: String
  
  var body: some View {
    Form {
      AppFormSection {
        VStack(alignment: .leading) {
          Text("comment.inThread")
            .font(.caption2)
          Text(postName)
        }
        .listRowBackground(Color.clear)
      }
      
      AppFormSection {
        TextField("comment.content", text: $vm.newCommentForm.content, axis: .vertical)
          .lineLimit(12)
      }
    }
    .listSectionSpacing(4)
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .navigationTitle("comment.newComment")
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
      vm.load(postId: postId)
    }
  }
}

#Preview {
  NavigationStack {
    NewCommentSheet(
      postId: UUID(),
      postName: Placeholder.ForumPost.title
    )
  }
}
