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
  var isFeedbackLoading: Bool = false
  var isNewCommentSheetPresented: Bool = false
  
  var id: UUID?
  var post: ForumPostResponse?
  
  var reportTarget: ReportTarget? = nil
  
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
  
  func report(contentType: ReportContentType, content: String, id: UUID) {
    reportTarget = ReportTarget(id: id, contentType: contentType, content: content)
  }
        
  private func performFetchPost(id: UUID) async throws {
    let response: ForumPostResponse = try await NetworkService.shared.get(
      endpoint: "/forum/posts/\(id)",
      requiresAuth: true
    )
    post = response
  }
  
  private func performContentFeedback(feedback: FeedbackType, content: FeedbackContentType, id: UUID) async throws {
    let endpoint: String = "/forum/\(content.rawValue)/\(id)/\(feedback.rawValue)"
    let response: ForumPostResponse = try await NetworkService.shared.post(
      endpoint: endpoint,
      requiresAuth: true
    )
    post = response
  }
}
