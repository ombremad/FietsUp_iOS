//
//  ForumViewModel+Post.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 16/07/2026.
//

import Foundation

extension ForumViewModel {
  func refreshPost() async {
    isLoading = true
    defer { isLoading = false }
    
    guard let post else { return }
    await loadPost(id: post.id)
  }
  
  func loadPost(id: UUID) async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      let response = try await performFetchPost(id: id)
      self.post = response
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func performFetchPost(id: UUID) async throws -> ForumPostResponse {
    return try await NetworkService.shared.get(
      endpoint: "/forum/posts/\(id)",
      requiresAuth: true
    )
  }
}
