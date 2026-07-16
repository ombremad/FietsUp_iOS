//
//  ForumViewModel+Categories.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 16/07/2026.
//

import Foundation

extension ForumViewModel {
  func loadCategories() async {
    isLoading = true
    defer { isLoading = false }
    
    if categories.isEmpty { await refreshCategories() }
  }

  func refreshCategories() async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      let response = try await performFetchCategories()
      self.categories = response
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func performFetchCategories() async throws -> [ForumCategoryResponse] {
    return try await NetworkService.shared.get(
      endpoint: "/forum/categories",
      requiresAuth: true
    )
  }  
}
