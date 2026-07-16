//
//  NewPostSheet.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 01/06/2026.
//

import SwiftUI

struct NewPostSheet: View {
  @Environment(ForumViewModel.self) private var vm
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    @Bindable var vm = vm

    Form {
      AppFormSection {
        VStack(alignment: .leading) {
          Text("post.inCategory")
            .font(.caption2)
          Text(vm.category?.name ?? "")
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
    .presentationDetents([.medium, .large])
    
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("common.confirm", systemImage: "arrow.up", role: .confirm) {
          Task { await vm.submitPost() }
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
    NewPostSheet()
  }
}
