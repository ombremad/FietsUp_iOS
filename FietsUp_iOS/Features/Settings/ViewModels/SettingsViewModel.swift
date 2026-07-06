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
    var theme: ThemeSetting = .auto
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
    settingsForm.theme = ThemeService.shared.setting
  }
  
  func submit() async throws {
    isLoading = true
    defer { isLoading = false }
    
    try ValidationService.firstName(settingsForm.firstName)
    try ValidationService.lastName(settingsForm.lastName)
    try ValidationService.email(settingsForm.email)
    
    if let user = auth.currentUser {
      if settingsForm.firstName != user.firstName || settingsForm.lastName != user.lastName || settingsForm.email != user.email {
        try await performUpdateUser(user)
        await auth.forceRefresh()
      }
    }
    ThemeService.shared.setting = settingsForm.theme
  }
  
  private func performUpdateUser(_ user: User) async throws {
    let body = UserUpdateRequest(from: settingsForm, compareTo: user)
    let _: UserResponse = try await NetworkService.shared.patch(
      endpoint: "/users/me",
      body: body,
      requiresAuth: true
    )
  }
  
  func changePassword() async throws {
    isLoading = true
    defer { isLoading = false }
    
    try ValidationService.password(changePasswordForm.oldPassword)
    try ValidationService.password(changePasswordForm.newPassword)
    try ValidationService.passwordConfirmation(
      password: changePasswordForm.newPassword,
      confirmation: changePasswordForm.newPasswordConfirmation
    )
    try await performUpdateUserPassword()
    try auth.logout()
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
