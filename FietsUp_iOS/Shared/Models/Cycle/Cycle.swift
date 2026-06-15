//
//  Cycle.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/06/2026.
//

import Foundation

@Observable
final class Cycle {
  var color: CycleColor?
  var type: CycleType?
  var decoration: CycleDecoration?
  
  init(
    color: CycleColor? = nil,
    type: CycleType? = nil,
    decoration: CycleDecoration? = nil
  ) {
    self.color = color
    self.type = type
    self.decoration = decoration
  }
  
  convenience init(from dto: UserPublicResponse) {
    self.init(
      color: dto.cycleColor.map { CycleColor(from: $0) },
      type: dto.cycleType.map { CycleType(from: $0) },
      decoration: dto.cycleDecoration.map { CycleDecoration(from: $0) }
    )
  }
  
  convenience init(from dto: UserResponse) {
    self.init(
      color: dto.cycleColor.map { CycleColor(from: $0) },
      type: dto.cycleType.map { CycleType(from: $0) },
      decoration: dto.cycleDecoration.map { CycleDecoration(from: $0) }
    )
  }
}
