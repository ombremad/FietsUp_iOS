//
//  DangerCommentRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 10/06/2026.
//

import Foundation

struct DangerCommentRequest: Encodable {
  let content: String
  
  init(from form: NewDangerCommentViewModel.NewDangerCommentForm) {
    self.content = form.content
  }
}
