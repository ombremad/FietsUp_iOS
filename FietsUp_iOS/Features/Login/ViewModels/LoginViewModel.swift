//
//  LoginViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 04/05/2026.
//

import Foundation

@Observable
final class LoginViewModel {
  var loginForm = LoginForm()

  struct LoginForm {
    var email: String = ""
    var password: String = ""
  }
  
  func login() async throws {
    try ValidationService.email(loginForm.email)
  }
}
