//
//  PatchForumCategoryRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 10/07/2026.
//

struct PatchForumCategoryRequest: Encodable {
  let name: String?
  let details: String?
  
  init(from form: AdminForumCategoriesViewModel.CategoryForm, compareTo old: ForumCategoryResponse) {
    self.name = form.name != old.name ? form.name : nil
    self.details = form.details != old.details ? form.details : nil
  }
}
