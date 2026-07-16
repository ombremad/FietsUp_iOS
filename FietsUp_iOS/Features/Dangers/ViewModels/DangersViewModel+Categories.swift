//
//  DangersViewModel+Categories.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 16/07/2026.
//

import Foundation

extension DangersViewModel {
  func loadCategories() async {
    isLoading = true
    defer { isLoading = false }
    
    if availableCategories.isEmpty {
      do {
        let response = try await performFetchCategories()
        self.availableCategories = response
      } catch {
        ErrorService.shared.show(error)
      }
    }
  }
  
  private func performFetchCategories() async throws -> [DangerCategoryResponse] {
    return try await NetworkService.shared.get(
      endpoint: "/dangers/categories",
      requiresAuth: true
    )
  }
}
