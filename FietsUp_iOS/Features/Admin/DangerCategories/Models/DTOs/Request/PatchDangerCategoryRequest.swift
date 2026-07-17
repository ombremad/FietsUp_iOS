//
//  PatchDangerCategoryRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 17/07/2026.
//

struct PatchDangerCategoryRequest: Encodable {
  let name: String?
  let iconName: String?
  
  init(from form: AdminDangerCategoriesViewModel.CategoryForm, compareTo old: DangerCategoryResponse) {
    self.name = form.name != old.name ? form.name : nil
    self.iconName = form.iconName != old.iconName ? form.iconName : nil
  }
}
