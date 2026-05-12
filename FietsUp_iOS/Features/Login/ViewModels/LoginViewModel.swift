//
//  LoginViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 04/05/2026.
//

import Foundation

@Observable
final class LoginViewModel {
  var isLoading: Bool = false

  var loginMode: LoginMode = .login
  enum LoginMode {
    case login, signup
  }

  var loginForm = LoginForm()
  struct LoginForm {
    var email: String = ""
    var password: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var nickname: String = ""
    var newPassword: String = ""
    var newPasswordConfirmation: String = ""
  }
  
  func submit() async {
    switch loginMode {
      case .login: await login()
      case .signup: await signup()
    }
  }
  
  func toggleMode() {
    switch loginMode {
      case .login: loginMode = .signup
      case .signup: loginMode = .login
    }
  }
  
  private func login() async {
    isLoading = true
    defer { isLoading = false }

    do {
      try ValidationService.email(loginForm.email)
      try ValidationService.password(loginForm.password)
      try await performLoginRequest()
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func signup() async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      try ValidationService.email(loginForm.email)
      try ValidationService.firstName(loginForm.firstName)
      try ValidationService.lastName(loginForm.lastName)
      try ValidationService.nickname(loginForm.nickname)
      try ValidationService.password(loginForm.newPassword)
      try ValidationService.passwordConfirmation(
        password: loginForm.newPassword,
        confirmation: loginForm.newPasswordConfirmation
      )
      try await performSignupRequest()
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func performLoginRequest() async throws {
    let body = LoginRequest(from: loginForm)
    let response: AuthResponse = try await NetworkService.shared.post(
      endpoint: "/users/login",
      body: body
    )
    try AuthService.shared.authenticate(token: response.token, user: response.user)
  }
  
  private func performSignupRequest() async throws {
    let body = SignupRequest(from: loginForm)
    let response: AuthResponse = try await NetworkService.shared.post(
      endpoint: "/users/signup",
      body: body
    )
    try AuthService.shared.authenticate(token: response.token, user: response.user)
  }
}
