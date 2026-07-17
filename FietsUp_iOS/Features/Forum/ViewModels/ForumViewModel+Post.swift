//
//  ForumViewModel+Post.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 16/07/2026.
//

import Foundation

extension ForumViewModel {
  func loadPost(id: UUID) async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      let response = try await performFetchPost(id: id)
      self.post = response
      self.postMetadata = response.comments.metadata
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
  
  private func goToPostPage(_ page: Int) async {
    guard !isLoading, page <= postMetadata.pageCount, page > 0, page != postMetadata.page, let post else { return }
    
    isLoading = true
    defer { isLoading = false }
    
    let previousPage = postMetadata.page
    postMetadata.page = page
    
    do {
      let response = try await performFetchPost(id: post.id)
      self.post = response
      self.postMetadata = response.comments.metadata
    } catch {
      postMetadata.page = previousPage
      ErrorService.shared.show(error)
    }
  }
  
  func goToPostNextPage() async {
    await goToPostPage(postMetadata.page + 1)
  }
  
  func goToPostPreviousPage() async {
    await goToPostPage(postMetadata.page - 1)
  }

  private func performFetchPost(id: UUID) async throws -> ForumPostPaginatedResponse {
    return try await NetworkService.shared.get(
      endpoint: "/forum/posts/\(id)?page=\(postMetadata.page)&per=\(postMetadata.per)",
      requiresAuth: true
    )
  }
}
