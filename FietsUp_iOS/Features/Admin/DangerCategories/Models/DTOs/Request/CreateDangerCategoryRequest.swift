//
//  CreateDangerCategoryRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 17/07/2026.
//

struct CreateDangerCategoryRequest: Encodable {
  let name: String
  let iconName: String
  
  init(from form: AdminDangerCategoriesViewModel.CategoryForm) {
    self.name = form.name
    self.iconName = form.iconName
  }
}
