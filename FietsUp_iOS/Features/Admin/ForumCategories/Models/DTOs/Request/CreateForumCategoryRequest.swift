//
//  CreateForumCategoryRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 10/07/2026.
//

struct CreateForumCategoryRequest: Encodable {
  let name: String
  let details: String
  
  init(from form: AdminForumCategoriesViewModel.CategoryForm) {
    self.name = form.name
    self.details = form.details
  }
}
