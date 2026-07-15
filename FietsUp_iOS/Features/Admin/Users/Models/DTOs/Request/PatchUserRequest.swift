//
//  PatchUserAdminRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/07/2026.
//

import Foundation

struct PatchUserAdminRequest: Encodable {
  let email: String?
  let nickname: String?
  let firstName: String?
  let lastName: String?
  let bio: String?
  let adminRights: Int?
  
  init(from form: AdminUsersViewModel.UserForm, compareTo old: UserResponse) {
    self.email = form.email != old.email ? form.email : nil
    self.nickname = form.nickname != old.nickname ? form.nickname : nil
    self.firstName = form.firstName != old.firstName ? form.firstName : nil
    self.lastName = form.lastName != old.lastName ? form.lastName : nil
    self.bio = form.bio != (old.bio ?? "") ? form.bio : nil
    self.adminRights = form.rights.rawValue != old.adminRights ? form.rights.rawValue : nil
  }
}
