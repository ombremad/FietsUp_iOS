//
//  CreatePlaceCategoryRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 10/07/2026.
//

struct CreatePlaceCategoryRequest: Encodable {
  let name: String
  let iconName: String
  
  init(from form: AdminPlaceCategoriesViewModel.CategoryForm) {
    self.name = form.name
    self.iconName = form.iconName.lowercased()
  }
}
