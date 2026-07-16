//
//  DangersViewModel+Posts.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 16/07/2026.
//

extension DangersViewModel {
  func loadPosts() async {
    isLoading = true
    defer { isLoading = false }
    
    locationService.requestLocation()
    if posts.isEmpty { await refreshPosts() }
  }
  
  func refreshPosts() async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      let response = try await performFetchDangerPosts()
      self.posts = response
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func performFetchDangerPosts() async throws -> [DangerPostShortResponse] {
    if let latitude, let longitude {
      return try await NetworkService.shared.get(
        endpoint: "/dangers/posts/near/?latitude=\(latitude)&longitude=\(longitude)",
        requiresAuth: true
      )
    } else {
      return []
    }
  }  
}
