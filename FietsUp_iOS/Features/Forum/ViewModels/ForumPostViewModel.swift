//
//  ForumPostViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 17/05/2026.
//

import Foundation

@Observable
final class ForumPostViewModel {
  var isLoading: Bool = false
  
  var id: UUID?
  var post: ForumPostResponse?
  
  func load(id: UUID) async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      self.id = id
      try await performFetchPost()
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func performFetchPost() async throws {
    if let id = id {
      let response: ForumPostResponse = try await NetworkService.shared.get(
        endpoint: "/forum/posts/\(id)",
        requiresAuth: true
      )
      post = response
    }
  }
}
