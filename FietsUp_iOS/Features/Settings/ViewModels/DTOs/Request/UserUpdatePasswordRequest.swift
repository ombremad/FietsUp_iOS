//
//  UserUpdatePasswordRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 12/05/2026.
//

import Foundation

struct UserUpdatePasswordRequest: Encodable {
  let oldPassword: String
  let newPassword: String
  
  init(from form: SettingsViewModel.ChangePasswordForm) {
    self.oldPassword = form.oldPassword
    self.newPassword = form.newPassword
  }
}
