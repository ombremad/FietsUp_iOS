//
//  UserProfileUpdateRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 30/06/2026.
//

import Foundation

struct UserProfileUpdateRequest: Encodable {
  let nickname: String?
  let bio: String?
  let cycleTypeId: UUID?
  let cycleColorId: UUID?
  let cycleDecorationId: UUID?
  
  init(from form: ProfileViewModel.ProfileForm, compareTo user: User) {
    self.nickname = form.nickname != user.nickname ? form.nickname : nil
    self.bio = form.bio != user.bio ? form.bio : nil
    self.cycleTypeId = form.cycleType?.id
    self.cycleColorId = form.cycleColor?.id
    self.cycleDecorationId = form.cycleDecoration?.id
  }
}
