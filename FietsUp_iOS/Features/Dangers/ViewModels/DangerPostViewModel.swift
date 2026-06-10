//
//  DangerPostViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 09/06/2026.
//

import Foundation

@Observable
final class DangerPostViewModel {
  var isLoading: Bool = false
  
  var id: UUID?
  var post: DangerPostResponse?
  
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
      let response: DangerPostResponse = try await NetworkService.shared.get(
        endpoint: "/dangers/posts/\(id)",
        requiresAuth: true
      )
      post = response
    }
  }
}
