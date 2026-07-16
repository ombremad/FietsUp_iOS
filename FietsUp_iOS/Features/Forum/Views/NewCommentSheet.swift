//
//  NewCommentSheet.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 02/06/2026.
//

import SwiftUI

struct NewCommentSheet: View {
  @Environment(ForumViewModel.self) private var vm
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    @Bindable var vm = vm
    
    Form {
      AppFormSection {
        VStack(alignment: .leading) {
          Text("comment.inThread")
            .font(.caption2)
          Text(vm.post?.title ?? "")
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
    .presentationDetents([.medium, .large])
    
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("common.confirm", systemImage: "arrow.up", role: .confirm) {
          Task { await vm.submitComment() }
        }.disabled(vm.isLoading)
      }
      ToolbarItem(placement: .cancellationAction) {
        Button("common.cancel", systemImage: "xmark", role: .cancel) { dismiss() }
      }
    }
  }
}

#Preview {
  NavigationStack {
    NewCommentSheet()
  }
}
