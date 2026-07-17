//
//  AdminForumCategoriesViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 08/07/2026.
//

import Foundation
import SwiftUI

@Observable
final class AdminForumCategoriesViewModel {
  var isLoading: Bool = false
  var isSingleCategorySheetPresented: Bool = false
  var metadata: PageMetadata = Defaults.pagination.metadata
  
  var categories: [ForumCategoryResponse] = []
  
  var category: ForumCategoryResponse? = nil
  var categoryForm = CategoryForm()
  struct CategoryForm {
    var name: String = ""
    var details: String = ""
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
  
  func edit(_ category: ForumCategoryResponse) {
    self.category = category
    categoryForm = .init(name: category.name, details: category.details)
    isSingleCategorySheetPresented = true
  }
  
  func submit() async throws {
    isLoading = true
    defer { isLoading = false }
        
    try ValidationService.name(categoryForm.name)
    try ValidationService.details(categoryForm.details)

    if category != nil {
      try await performPatchCategory()
    } else {
      try await performCreateCategory()
    }
    
    try await refreshCategories()
  }
  
  func delete(at offsets: IndexSet) async {
    let toDelete = offsets.map { categories[$0] }
    do {
      for category in toDelete {
        try await performDeleteCategory(id: category.id)
      }
      try await refreshCategories()
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func performCreateCategory() async throws {
    let body = CreateForumCategoryRequest(from: categoryForm)
    
    let _: ForumCategoryShortResponse = try await NetworkService.shared.post(
      endpoint: "/forum/categories/admin",
      body: body,
      requiresAuth: true
    )
  }

  private func performPatchCategory() async throws {
    guard let oldCategory = category else { return }
    let body = PatchForumCategoryRequest(from: categoryForm, compareTo: oldCategory)
    
    let _: ForumCategoryShortResponse = try await NetworkService.shared.patch(
      endpoint: "/forum/categories/admin/\(oldCategory.id)",
      body: body,
      requiresAuth: true
    )
  }
    
  private func performDeleteCategory(id: UUID) async throws {
    return try await NetworkService.shared.delete(
      endpoint: "/forum/categories/admin/\(id)",
      requiresAuth: true
    )
  }

  private func performFetchCategories() async throws -> Page<ForumCategoryResponse> {
    return try await NetworkService.shared.get(
      endpoint: "/forum/categories/admin?page=\(metadata.page)&per=\(metadata.per)",
      requiresAuth: true
    )
  }
}
