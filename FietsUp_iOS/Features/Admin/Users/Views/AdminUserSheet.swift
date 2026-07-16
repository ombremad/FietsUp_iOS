//
//  AdminUserSheet.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/07/2026.
//

import SwiftUI

struct AdminUserSheet: View {
  @Environment(AdminUsersViewModel.self) var vm
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    @Bindable var vm = vm
    Form {
      AppFormSection {
        LabeledContent("admin.user.email") {
          TextField("", text: $vm.userForm.email)
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
        }
        LabeledContent("admin.user.nickname") {
          TextField("", text: $vm.userForm.nickname)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
        }
        LabeledContent("admin.user.firstName") {
          TextField("", text: $vm.userForm.firstName)
            .autocorrectionDisabled()
        }
        LabeledContent("admin.user.lastName") {
          TextField("admin.user.lastName", text: $vm.userForm.lastName)
            .autocorrectionDisabled()
        }
        LabeledContent("admin.user.bio") {
          TextField("admin.user.bio", text: $vm.userForm.bio, axis: .vertical)
            .lineLimit(3)
        }
        Picker("admin.user.rights", selection: $vm.userForm.rights) {
          ForEach(UserRights.allCases, id: \.self) { right in
            Text(right.name).tag(right)
          }
        }
        Toggle("admin.user.isBanned", isOn: Binding(
          get: { vm.userForm.isBanned },
          set: { vm.setBanDefaults($0) }
        ))
        if vm.userForm.isBanned {
          DatePicker(
            "admin.user.banEndDate",
            selection: Binding(
              get: { vm.userForm.banEndDate ?? Defaults.values.banEndDate },
              set: { vm.userForm.banEndDate = $0 }
            ),
            displayedComponents: .date
          )
        }
      }
    }
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .labeledContentStyle(AppLabeledContent())
    .scrollContentBackground(.hidden)
    .navigationTitle("admin.user.title")
    .navigationBarTitleDisplayMode(.inline)
    .presentationDetents([.large])

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
