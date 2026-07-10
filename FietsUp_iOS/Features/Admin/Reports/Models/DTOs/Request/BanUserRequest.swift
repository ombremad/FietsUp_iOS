//
//  BanUserRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 08/07/2026.
//

import Foundation

struct BanUserRequest: Encodable {
  let banEndDate: Date
  
  init(until banEndDate: Date) {
    self.banEndDate = banEndDate
  }
}
