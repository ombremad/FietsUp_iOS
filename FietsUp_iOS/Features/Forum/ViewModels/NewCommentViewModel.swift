//
//  NewCommentViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 02/06/2026.
//

import Foundation

@Observable
final class NewCommentViewModel {
  var isLoading: Bool = false
  var postId: UUID?
  
  var newCommentForm = NewCommentForm()
  struct NewCommentForm {
    var content: String = ""
  }
  
  func load(postId: UUID) {
    self.postId = postId
  }
  
  func submit() async throws {
    isLoading = true
    defer { isLoading = false }
    
    try ValidationService.content(newCommentForm.content)
    try await performNewCommentRequest()
  }
  
  private func performNewCommentRequest() async throws {
    if let postId {
      let body = ForumCommentRequest(from: newCommentForm)
      let _: ForumCommentResponse = try await NetworkService.shared.post(
        endpoint: "/forum/comments/post/\(postId)",
        body: body,
        requiresAuth: true
      )
      EventService.post(ForumRefresh.refreshPostView)
      EventService.post(ForumRefresh.refreshCategoryView)
      EventService.post(ForumRefresh.refreshForumView)
    }
  }
}
