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
  
  private var observationTask: Task<Void, Never>?
  init() {
    observationTask = Task { @MainActor [weak self] in
      for await _ in EventService.stream(for: ForumRefresh.refreshCategoryView) {
        if let id = self?.id { await self?.load(id: id) }
      }
    }
  }
  deinit { observationTask?.cancel() }
  
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
