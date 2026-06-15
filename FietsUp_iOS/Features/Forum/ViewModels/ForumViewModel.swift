//
//  ForumViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/05/2026.
//

import Foundation

@Observable
final class ForumViewModel {
  var isLoading: Bool = false
  
  var categories: [ForumCategoryResponse] = []
  
  private var observationTask: Task<Void, Never>?
  init() {
    observationTask = Task { @MainActor [weak self] in
      for await _ in EventService.stream(for: ForumRefresh.refreshForumView) {
        await self?.load()
      }
    }
  }
  deinit { observationTask?.cancel() }
  
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
