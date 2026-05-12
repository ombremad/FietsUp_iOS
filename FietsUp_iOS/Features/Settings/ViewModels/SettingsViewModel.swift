//
//  SettingsViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 12/05/2026.
//

import Foundation

@Observable
final class SettingsViewModel {
  private let auth = AuthService.shared
  var isLoading: Bool = false
  
  var isLogoutAlertPresented: Bool = false
  var isPasswordChangeAlertPresented: Bool = false
  
  var settingsForm = SettingsForm()
  struct SettingsForm {
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
  }

  var changePasswordForm = ChangePasswordForm()
  struct ChangePasswordForm {
    var oldPassword: String = ""
    var newPassword: String = ""
    var newPasswordConfirmation: String = ""
  }
    
  func load() {
    if let user = auth.currentUser {
      settingsForm.firstName = user.firstName
      settingsForm.lastName = user.lastName
      settingsForm.email = user.email
    }
  }
  
  func submit() async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      try ValidationService.firstName(settingsForm.firstName)
      try ValidationService.lastName(settingsForm.lastName)
      try ValidationService.email(settingsForm.email)
    } catch {
      ErrorService.shared.show(error)
    }
    
    if let user = auth.currentUser {
      if settingsForm.firstName != user.firstName || settingsForm.lastName != user.lastName || settingsForm.email != user.email {
        do {
          try await performUpdateUser(user)
          await auth.forceRefresh()
        } catch {
          ErrorService.shared.show(error)
        }
      }
    }
  }
  
  private func performUpdateUser(_ user: User) async throws {
    let body = UserUpdateRequest(from: settingsForm, compareTo: user)
    let _: UserResponse = try await NetworkService.shared.patch(
      endpoint: "/users/me",
      body: body,
      requiresAuth: true
    )
  }
  
  func changePassword() async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      try ValidationService.password(changePasswordForm.oldPassword)
      try ValidationService.password(changePasswordForm.newPassword)
      try ValidationService.passwordConfirmation(
        password: changePasswordForm.newPassword,
        confirmation: changePasswordForm.newPasswordConfirmation
      )
      try await performUpdateUserPassword()
      try auth.logout()
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func performUpdateUserPassword() async throws {
    let body = UserUpdatePasswordRequest(from: changePasswordForm)
    let _: UserResponse = try await NetworkService.shared.patch(
      endpoint: "/users/me/password",
      body: body,
      requiresAuth: true
    )
  }
}
