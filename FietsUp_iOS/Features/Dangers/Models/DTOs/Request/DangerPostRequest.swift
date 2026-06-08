//
//  DangerPostRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 08/06/2026.
//

import Foundation
struct DangerPostRequest: Encodable {
  let title: String
  let content: String
  let latitude: Double
  let longitude: Double
  
  init(from form: NewDangerPostViewModel.NewDangerPostForm, latitude: Double, longitude: Double) {
    self.title = form.title
    self.content = form.content
    self.latitude = latitude
    self.longitude = longitude
  }
}
