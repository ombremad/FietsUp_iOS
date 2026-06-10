//
//  ReportRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 10/06/2026.
//

import Foundation

struct ReportRequest: Encodable {
  let details: String?
  let categoryId: UUID
  
  init(from form: NewReportViewModel.NewReportForm) {
    self.details = form.hasDetails ? nil : form.details
    self.categoryId = form.categoryId!
  }
}
