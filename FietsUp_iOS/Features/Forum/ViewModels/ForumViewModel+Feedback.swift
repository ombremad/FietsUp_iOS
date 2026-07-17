//
//  ForumViewModel+Feedback.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 16/07/2026.
//

import Foundation

extension ForumViewModel {
  func newFeedback(
    id: UUID,
    feedback: FeedbackType,
    content: FeedbackContentType,
  ) async {
    isFeedbackLoading = true
    defer { isFeedbackLoading = false }
    
    do {
      let response = try await performContentFeedback(id: id, feedback: feedback, content: content)
      self.post = response
      self.postMetadata = response.comments.metadata
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func performContentFeedback(
    id: UUID,
    feedback: FeedbackType,
    content: FeedbackContentType,
  ) async throws -> ForumPostPaginatedResponse {
    let endpoint: String = "/forum/\(content.rawValue)/\(id)/\(feedback.rawValue)"
    return try await NetworkService.shared.post(
      endpoint: endpoint,
      requiresAuth: true
    )
  }
}
