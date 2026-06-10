//
//  ReportTarget.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 10/06/2026.
//

import Foundation

struct ReportTarget: Identifiable {
  let id: UUID
  let contentType: ReportContentType
  let content: String
}
