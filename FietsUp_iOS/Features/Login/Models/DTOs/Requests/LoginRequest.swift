//
//  LoginRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 04/05/2026.
//

import Foundation

struct LoginRequest: Encodable {
  let email: String
  let password: String
  
  init(from form: LoginViewModel.LoginForm) {
    self.email = form.email
    self.password = form.password
  }
}
