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
  var isFeedbackLoading: Bool = false
  var isNewCommentSheetPresented: Bool = false
  
  var id: UUID?
  var post: DangerPostResponse?
  
  enum FeedbackType: String { case like = "like", fav = "fav" }
  enum FeedbackContentType: String { case post = "posts", comment = "comments" }
  
  func load(id: UUID) async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      self.id = id
      try await performFetchPost(id: id)
    } catch {
      ErrorService.shared.show(error)
    }
  }
    
  func feedback(feedback: FeedbackType, content: FeedbackContentType, id: UUID) async {
    isFeedbackLoading = true
    defer { isFeedbackLoading = false }

    do {
      try await performContentFeedback(feedback: feedback, content: content, id: id)
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func performFetchPost(id: UUID) async throws {
    let response: DangerPostResponse = try await NetworkService.shared.get(
      endpoint: "/dangers/posts/\(id)",
      requiresAuth: true
    )
    post = response
  }
  
  private func performContentFeedback(feedback: FeedbackType, content: FeedbackContentType, id: UUID) async throws {
    let endpoint: String = "/dangers/\(content.rawValue)/\(id)/\(feedback.rawValue)"
    let response: DangerPostResponse = try await NetworkService.shared.post(
      endpoint: endpoint,
      requiresAuth: true
    )
    post = response
  }
}
