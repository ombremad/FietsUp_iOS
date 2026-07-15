//
//  PatchModerationCategoryRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/07/2026.
//

struct PatchModerationCategoryRequest: Encodable {
  let name: String?
  
  init(from form: AdminModerationCategoriesViewModel.CategoryForm, compareTo old: ModerationCategoryResponse) {
    self.name = form.name != old.name ? form.name : nil
  }
}
