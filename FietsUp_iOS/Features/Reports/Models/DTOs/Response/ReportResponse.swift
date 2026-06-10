//
//  ReportResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 10/06/2026.
//

import Foundation

struct ReportResponse: Decodable {
  let id: UUID
  let details: String?
  let category: ReportCategoryResponse
  let creationDate: Date
}
