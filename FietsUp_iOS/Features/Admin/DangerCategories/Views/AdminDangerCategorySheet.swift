//
//  AdminDangerCategorySheet.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 17/07/2026.
//

import SwiftUI

struct AdminDangerCategorySheet: View {
  @Environment(AdminDangerCategoriesViewModel.self) private var vm
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    @Bindable var vm = vm
    Form {
      AppFormSection {
        LabeledContent("admin.dangerCategory.name") {
          TextField("", text: $vm.categoryForm.name)
            .submitLabel(.done)
        }
        LabeledContent("admin.dangerCategory.iconName") {
          TextField("", text: $vm.categoryForm.iconName)
            .submitLabel(.done)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
        }
      }
    }
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .labeledContentStyle(AppLabeledContent())
    .scrollContentBackground(.hidden)
    .scrollDismissesKeyboard(.immediately)
    .navigationTitle("admin.dangerCategory.title")
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
