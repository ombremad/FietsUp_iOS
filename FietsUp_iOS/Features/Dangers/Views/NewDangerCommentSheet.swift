//
//  NewDangerCommentSheet.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 10/06/2026.
//

import SwiftUI

struct NewDangerCommentSheet: View {
  @State private var vm = NewDangerCommentViewModel()
  @Environment(\.dismiss) private var dismiss
  
  var onSuccess: (() -> Void)? = nil
  
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
        TextField("comment.content", text: $vm.newDangerCommentForm.content, axis: .vertical)
          .lineLimit(12)
      }
    }
    .listSectionSpacing(4)
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .navigationTitle("comment.newComment")
    .navigationBarTitleDisplayMode(.inline)
    .presentationDetents([.medium, .large])
    
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("common.confirm", systemImage: "arrow.up", role: .confirm) {
          Task {
            do {
              try await vm.submit()
              onSuccess?()
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
