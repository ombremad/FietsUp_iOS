//
//  ForumCategoryViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/05/2026.
//

import Foundation

@Observable
final class ForumCategoryViewModel {
  var isLoading: Bool = false
  var isNewPostSheetPresented: Bool = false
  
  var id: UUID?
  var category: ForumCategoryDetailedResponse?
  
  func load(id: UUID) async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      self.id = id
      try await performFetchCategory()
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func performFetchCategory() async throws {
    if let id = id {
      let response: ForumCategoryDetailedResponse = try await NetworkService.shared.get(
        endpoint: "/forum/categories/\(id)",
        requiresAuth: true
      )
      category = response
    }
  }
}
