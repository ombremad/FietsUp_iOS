//
//  CreateModerationCategoryRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/07/2026.
//

struct CreateModerationCategoryRequest: Encodable {
  let name: String
  
  init(from form: AdminModerationCategoriesViewModel.CategoryForm) {
    self.name = form.name
  }
}
