//
//  NewActivityRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 12/05/2026.
//

import Foundation

struct ActivityRequest: Encodable {
  let startDate: Date
  let endDate: Date
  let distance: Int
  
  init (from form: NewActivityViewModel.NewActivityForm) {
    self.startDate = form.startDate
    self.endDate = form.endDate
    self.distance = form.distance
  }
}
