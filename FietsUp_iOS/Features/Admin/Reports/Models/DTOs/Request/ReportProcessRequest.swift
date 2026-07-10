//
//  ReportProcess.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 06/07/2026.
//

import Foundation

struct ReportProcessRequest: Encodable {
  let details: String
  
  init(from form: AdminReportsViewModel.ReportActionForm) {
    self.details = form.details
  }
}
