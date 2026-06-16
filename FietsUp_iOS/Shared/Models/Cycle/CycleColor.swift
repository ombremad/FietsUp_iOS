//
//  CycleColor.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/06/2026.
//

import Foundation
import SwiftUI

@Observable
final class CycleColor {
  var id: UUID
  var name: String
  var color: String
  
  init(from dto: CycleColorResponse) {
    self.id = dto.id
    self.name = dto.name
    self.color = dto.color
  }
}
