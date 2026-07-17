//
//  ForumViewModel+Category.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 16/07/2026.
//

import Foundation

extension ForumViewModel {
  func loadCategory(id: UUID) async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      let response = try await performFetchCategory(id: id)
      self.category = response
      self.categoryMetadata = response.posts.metadata
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  func refreshCategory() async {
    isLoading = true
    defer { isLoading = false }
    
    guard let category else { return }
    await loadCategory(id: category.id)
  }
  
  func goToCategoryPage(_ page: Int) async {
    guard !isLoading, page <= categoryMetadata.pageCount, page > 0, page != categoryMetadata.page, let category else { return }
    
    isLoading = true
    defer { isLoading = false }
    
    let previousPage = categoryMetadata.page
    categoryMetadata.page = page
    
    do {
      let response = try await performFetchCategory(id: category.id)
      self.category = response
      self.categoryMetadata = response.posts.metadata
    } catch {
      categoryMetadata.page = previousPage
      ErrorService.shared.show(error)
    }
  }
  
  func goToCategoryNextPage() async {
    await goToCategoryPage(categoryMetadata.page + 1)
  }
  
  func goToCategoryPreviousPage() async {
    await goToCategoryPage(categoryMetadata.page - 1)
  }
  
  private func performFetchCategory(id: UUID) async throws -> ForumCategoryPaginatedResponse {
    return try await NetworkService.shared.get(
      endpoint: "/forum/categories/\(id)?page=\(categoryMetadata.page)&per=\(categoryMetadata.per)",
      requiresAuth: true
    )
  }
}
