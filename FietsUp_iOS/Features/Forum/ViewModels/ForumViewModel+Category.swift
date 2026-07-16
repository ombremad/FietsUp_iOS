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
  
  private func performFetchCategory(id: UUID) async throws -> ForumCategoryDetailedResponse {
    return try await NetworkService.shared.get(
      endpoint: "/forum/categories/\(id)",
      requiresAuth: true
    )
  }
}
