//
//  ActivityResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 12/05/2026.
//

import Foundation

struct ActivityResponse: Decodable, Identifiable {
  let id: UUID
  let startDate: Date
  let endDate: Date
  let length: Int
  let distance: Int
}
