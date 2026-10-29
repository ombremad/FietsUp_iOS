//
//  AdminDangerCategoriesViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 17/07/2026.
//

import Foundation

@Observable
final class AdminDangerCategoriesViewModel {
  var isLoading: Bool = false
  var isSingleCategorySheetPresented: Bool = false
  
  var categories: [DangerCategoryResponse] = []
  
  var category: DangerCategoryResponse? = nil
  var categoryForm = CategoryForm()
  struct CategoryForm {
    var name: String = ""
    var iconName: String = ""
  }
  
  func load() async {
    isLoading = true
    defer { isLoading = false }
    
    guard categories.isEmpty else { return }
    do {
      try await refreshCategories()
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  func refreshCategories() async throws {
    categories = try await performFetchCategories()
  }
  
  func create() {
    category = nil
    categoryForm = .init()
    isSingleCategorySheetPresented = true
  }
  
  func edit(_ category: DangerCategoryResponse) {
    self.category = category
    categoryForm = .init(name: category.name, iconName: category.iconName)
    isSingleCategorySheetPresented = true
  }
  
  func submit() async throws {
    isLoading = true
    defer { isLoading = false }
    
    try ValidationService.name(categoryForm.name)
    try ValidationService.iconName(categoryForm.iconName)
    
    if category != nil {
      try await performPatchCategory()
    } else {
      try await performCreateCategory()
    }
    
    try await refreshCategories()
  }
  
  private func performCreateCategory() async throws {
    let body = CreateDangerCategoryRequest(from: categoryForm)
    
    let _: DangerCategoryResponse = try await NetworkService.shared.post(
      endpoint: "/dangers/categories/",
      body: body,
      requiresAuth: true
    )
  }
  
  private func performPatchCategory() async throws {
    guard let oldCategory = category else { return }
    let body = PatchDangerCategoryRequest(from: categoryForm, compareTo: oldCategory)
    
    let _: DangerCategoryResponse = try await NetworkService.shared.patch(
      endpoint: "/dangers/categories/\(oldCategory.id)",
      body: body,
      requiresAuth: true
    )
  }
  
  private func performFetchCategories() async throws -> [DangerCategoryResponse] {
    return try await NetworkService.shared.get(
      endpoint: "/dangers/categories",
      requiresAuth: true
    )
  }
}
