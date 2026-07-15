//
//  AdminModerationCategorySheet.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/07/2026.
//

import SwiftUI

struct AdminModerationCategorySheet: View {
  @Environment(AdminModerationCategoriesViewModel.self) var vm
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    @Bindable var vm = vm
    Form {
      AppFormSection {
        TextField("admin.moderationCategory.name", text: $vm.categoryForm.name)
      }
    }
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .scrollContentBackground(.hidden)
    .navigationTitle("admin.moderationCategory.title")
    .navigationBarTitleDisplayMode(.inline)
    .presentationDetents([.fraction(0.3)])
    
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
