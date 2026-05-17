//
//  ForumViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/05/2026.
//

import Foundation

enum ForumDestination: Hashable {
  case category(id: UUID)
}

@Observable
final class ForumViewModel {
  var isLoading: Bool = false
  
  var categories: [ForumCategoryResponse] = []
  
  func load() async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      try await performFetchCategories()
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func performFetchCategories() async throws {
    let response: [ForumCategoryResponse] = try await NetworkService.shared.get(
      endpoint: "/forum/categories",
      requiresAuth: true
    )
    categories = response
  }
}
