//
//  ReportCategoryResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 10/06/2026.
//

import Foundation

struct ReportCategoryResponse: Decodable, Identifiable {
  let id: UUID
  let name: String
}
