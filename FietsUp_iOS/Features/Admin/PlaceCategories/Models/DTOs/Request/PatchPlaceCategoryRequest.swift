//
//  PatchPlaceCategoryRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 10/07/2026.
//

struct PatchPlaceCategoryRequest: Encodable {
  let name: String?
  let iconName: String?
  
  init(from form: AdminPlaceCategoriesViewModel.CategoryForm, compareTo old: PlaceCategoryResponse) {
    self.name = form.name != old.name ? form.name : nil
    self.iconName = form.iconName != old.iconName ? form.iconName.lowercased() : nil
  }
}
