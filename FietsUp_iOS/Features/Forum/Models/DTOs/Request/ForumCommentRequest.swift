//
//  ForumCommentRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 02/06/2026.
//

import Foundation

struct ForumCommentRequest: Encodable {
  let content: String
  
  init (from form: NewCommentViewModel.NewCommentForm) {
    self.content = form.content
  }
}
