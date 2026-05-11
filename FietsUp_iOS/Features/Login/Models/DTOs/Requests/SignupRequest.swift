//
//  SignupRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 04/05/2026.
//

import Foundation

struct SignupRequest: Encodable {
  let email: String
  let password: String
  let firstName: String
  let lastName: String
  let nickname: String
  
  init(from form: LoginViewModel.LoginForm) {
    self.email = form.email
    self.password = form.newPassword
    self.firstName = form.firstName
    self.lastName = form.lastName
    self.nickname = form.nickname
  }
}
