//
//  DangersViewModel+Feedback.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 16/07/2026.
//

import Foundation

extension DangersViewModel {
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
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func performContentFeedback(
    id: UUID,
    feedback: FeedbackType,
    content: FeedbackContentType,
  ) async throws -> DangerPostResponse {
    let endpoint: String = "/dangers/\(content.rawValue)/\(id)/\(feedback.rawValue)"
    return try await NetworkService.shared.post(
      endpoint: endpoint,
      requiresAuth: true
    )
  }
}
