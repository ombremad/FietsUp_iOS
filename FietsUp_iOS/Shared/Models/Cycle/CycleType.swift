//
//  CycleType.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/06/2026.
//

import Foundation

@Observable
final class CycleType {
  var id: UUID
  var name: String
  var fileLink: String
  
  init(with dto: CycleType) {
    self.id = dto.id
    self.name = dto.name
    self.fileLink = dto.fileLink
  }
}

