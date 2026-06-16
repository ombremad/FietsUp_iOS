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
  var fileLink: URL
  
  init(from dto: CycleTypeResponse) {
    self.id = dto.id
    self.name = dto.name
    self.fileLink = URL(string: dto.fileLink)!
  }
}

