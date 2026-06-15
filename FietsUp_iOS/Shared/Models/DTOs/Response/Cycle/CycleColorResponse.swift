//
//  CycleColorResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/06/2026.
//

import Foundation

struct CycleColorResponse: Decodable {
  let id: UUID
  let name: String
  let color: String
}
