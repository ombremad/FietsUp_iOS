//
//  ForumPostRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 01/06/2026.
//

import Foundation

struct ForumPostRequest: Encodable {
  let title: String
  let content: String
  
  init (from form: NewPostViewModel.NewPostForm) {
    self.title = form.title
    self.content = form.content
  }
}
