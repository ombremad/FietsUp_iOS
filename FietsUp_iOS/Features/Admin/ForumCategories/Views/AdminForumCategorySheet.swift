//
//  AdminForumCategorySheet.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 10/07/2026.
//

import SwiftUI

struct AdminForumCategorySheet: View {
  @Environment(AdminForumCategoriesViewModel.self) private var vm
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    @Bindable var vm = vm
    Form {
      AppFormSection {
        LabeledContent("admin.forumCategory.name") {
          TextField("", text: $vm.categoryForm.name)
            .submitLabel(.done)
        }
        LabeledContent("admin.forumCategory.details") {
          TextField("", text: $vm.categoryForm.details, axis: .vertical)
            .lineLimit(3)
        }
      }
    }
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .labeledContentStyle(AppLabeledContent())
    .scrollContentBackground(.hidden)
    .scrollDismissesKeyboard(.immediately)
    .navigationTitle("admin.forumCategory.title")
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
  }
}
