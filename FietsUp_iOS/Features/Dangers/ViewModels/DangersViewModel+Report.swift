//
//  DangersViewModel+Report.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 16/07/2026.
//

import Foundation

extension DangersViewModel {
  func newReport(id: UUID, contentType: ReportContentType, content: String) {
    newReportTarget = ReportTarget(id: id, contentType: contentType, content: content)
  }
}
