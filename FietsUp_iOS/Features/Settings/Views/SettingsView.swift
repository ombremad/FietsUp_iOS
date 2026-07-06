//
//  SettingsView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 12/05/2026.
//

import SwiftUI

struct SettingsView: View {
  @State private var vm = SettingsViewModel()
  private let auth = AuthService.shared
  
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    Form {
      AppFormSection("settings.myAccount") {
        Group {
          TextField("form.firstName", text: $vm.settingsForm.firstName)
            .textContentType(.givenName)
            .autocorrectionDisabled()
            .submitLabel(.done)
          
          TextField("form.lastName", text: $vm.settingsForm.lastName)
            .textContentType(.familyName)
            .autocorrectionDisabled()
            .submitLabel(.done)
          
          TextField("form.email", text: $vm.settingsForm.email)
            .textContentType(.emailAddress)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .keyboardType(.emailAddress)
            .submitLabel(.done)
        }
        .foregroundStyle(Color.Text.secondary)
        
        Button("settings.changePassword") { vm.isPasswordChangeAlertPresented.toggle()
        }.frame(maxWidth: .infinity)
        
        Button("settings.logout", role: .destructive) {
          vm.isLogoutAlertPresented.toggle()
        }.frame(maxWidth: .infinity)
        
      }
      
      AppFormSection("settings.settings") {
        Group {
          Picker("settings.theme", selection: $vm.settingsForm.theme) {
            ForEach(ThemeSetting.allCases, id: \.self) { option in
              Text(option.label).tag(option)
            }
          }
        }
        .foregroundStyle(Color.Text.secondary)
      }
    }
    .background { Color.Surface.background.ignoresSafeArea() }
    .navigationTitle("settings.title")
    .toolbarTitleDisplayMode(.inline)
    .scrollContentBackground(.hidden)
    .scrollDismissesKeyboard(.interactively)
    .task {
      vm.load()
    }
    
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("common.confirm", systemImage: "checkmark", role: .confirm) {
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
    }
    
    .alert("settings.logout", isPresented: $vm.isLogoutAlertPresented) {
      Button("logoutAlert.logout", role: .destructive) {
        Task { try auth.logout() }
      }.disabled(vm.isLoading)
      Button("common.cancel", role: .cancel) {}
    } message: {
      Text("logoutAlert.message")
    }
    
    .alert("settings.changePassword", isPresented: $vm.isPasswordChangeAlertPresented) {
      SecureField("form.oldPassword", text: $vm.changePasswordForm.oldPassword)
      SecureField("form.newPassword", text: $vm.changePasswordForm.newPassword)
      SecureField("form.newPasswordConfirmation", text: $vm.changePasswordForm.newPasswordConfirmation)
      Button("changePassword.update", role: .destructive) {
        Task {
          do { try await vm.changePassword() }
        }
      }.disabled(vm.isLoading)
      Button("common.cancel", role: .cancel) {}
    } message: {
      Text("changePassword.message")
    }
    
  }
}

#Preview {
  SettingsView()
}
