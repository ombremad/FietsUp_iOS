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
  var categories: [ForumCategoryResponse] = []
  
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
    let response = try await performFetchCategories()
    categories = response
  }
  
  func delete(at offsets: IndexSet) async {
    let toDelete = offsets.map { categories[$0] }
    do {
      for category in toDelete {
        try await NetworkService.shared.delete(
          endpoint: "/forum/categories/admin/\(category.id)",
          requiresAuth: true
        )
      }
      categories.remove(atOffsets: offsets)
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
