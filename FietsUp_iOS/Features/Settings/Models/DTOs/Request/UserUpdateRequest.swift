//
//  UserUpdateRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 12/05/2026.
//

struct UserUpdateRequest: Encodable {
  let firstName: String?
  let lastName: String?
  let email: String?
  
  init(from form: SettingsViewModel.SettingsForm, compareTo user: User) {
    self.firstName = form.firstName != user.firstName ? form.firstName : nil
    self.lastName = form.lastName != user.lastName ? form.lastName : nil
    self.email = form.email != user.email ? form.email : nil
  }
}
