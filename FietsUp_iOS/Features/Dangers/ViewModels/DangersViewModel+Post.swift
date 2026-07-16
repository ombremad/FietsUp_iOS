//
//  DangersViewModel+Post.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 16/07/2026.
//

import Foundation

extension DangersViewModel {
  func loadPost(id: UUID) async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      let response = try await performFetchDangerPost(id: id)
      self.post = response
      self.postApproximateLocation = nil
      self.postApproximateLocation = try await ReverseGeocoder.resolve(latitude: response.latitude, longitude: response.longitude)
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  func refreshPost() async {
    isLoading = true
    defer { isLoading = false }
    
    guard let post else { return }
    await loadPost(id: post.id)
  }
  
  private func performFetchDangerPost(id: UUID) async throws -> DangerPostResponse {
    return try await NetworkService.shared.get(
      endpoint: "/dangers/posts/\(id)",
      requiresAuth: true
    )
  }
}
