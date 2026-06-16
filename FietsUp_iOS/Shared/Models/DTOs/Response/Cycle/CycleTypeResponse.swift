//
//  CycleTypeResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/06/2026.
//

import Foundation

struct CycleTypeResponse: Decodable {
  let id: UUID
  let name: String
  let fileLink: String
}
