//
//  AdminModerationCategoriesViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/07/2026.
//

import Foundation

@Observable
final class AdminModerationCategoriesViewModel {
  var isLoading: Bool = false
  var isSingleCategorySheetPresented: Bool = false
  var metadata: PageMetadata = Defaults.pagination.metadata
  
  var categories: [ModerationCategoryResponse] = []
  
  var category: ModerationCategoryResponse? = nil
  var categoryForm = CategoryForm()
  struct CategoryForm {
    var name: String = ""
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
  
  func goToPage(_ page: Int) async {
    guard !isLoading, page <= metadata.pageCount, page > 0, page != metadata.page else { return }
    
    isLoading = true
    defer { isLoading = false }
    
    let previousPage = metadata.page
    metadata.page = page
    
    do {
      try await refreshCategories()
    } catch {
      metadata.page = previousPage
      ErrorService.shared.show(error)
    }
  }
  
  func goToNextPage() async {
    await goToPage(metadata.page + 1)
  }
  
  func goToPreviousPage() async {
    await goToPage(metadata.page - 1)
  }
  
  func refreshCategories() async throws {
    let response = try await performFetchCategories()
    categories = response.items
    metadata = response.metadata
    category = nil
    categoryForm = .init()
  }
  
  func create() {
    category = nil
    categoryForm = .init()
    isSingleCategorySheetPresented = true
  }
  
  func edit(_ category: ModerationCategoryResponse) {
    self.category = category
    categoryForm = .init(name: category.name)
    isSingleCategorySheetPresented = true
  }
  
  func submit() async throws {
    isLoading = true
    defer { isLoading = false }
    
    try ValidationService.name(categoryForm.name)
    
    if category != nil {
      try await performPatchCategory()
    } else {
      try await performCreateCategory()
    }
    
    try await refreshCategories()
  }
  
  private func performCreateCategory() async throws {
    let body = CreateModerationCategoryRequest(from: categoryForm)
    
    let _: ModerationCategoryResponse = try await NetworkService.shared.post(
      endpoint: "/moderation/categories/",
      body: body,
      requiresAuth: true
    )
  }
  
  private func performPatchCategory() async throws {
    guard let oldCategory = category else { return }
    let body = PatchModerationCategoryRequest(from: categoryForm, compareTo: oldCategory)
    
    let _: ModerationCategoryResponse = try await NetworkService.shared.patch(
      endpoint: "/moderation/categories/\(oldCategory.id)",
      body: body,
      requiresAuth: true
    )
  }
  
  private func performFetchCategories() async throws -> Page<ModerationCategoryResponse> {
    return try await NetworkService.shared.get(
      endpoint: "/moderation/categories?page=\(metadata.page)&per=\(metadata.per)",
      requiresAuth: true
    )
  }
}
