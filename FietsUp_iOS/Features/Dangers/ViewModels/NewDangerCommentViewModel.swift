//
//  NewDangerCommentViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 10/06/2026.
//

import Foundation

@Observable
final class NewDangerCommentViewModel {
  var isLoading: Bool = false
  var postId: UUID?
  
  var newDangerCommentForm = NewDangerCommentForm()
  struct NewDangerCommentForm {
    var content: String = ""
  }
  
  func load(postId: UUID) {
    self.postId = postId
  }
  
  func submit() async throws {
    isLoading = true
    defer { isLoading = false }
    
    try ValidationService.content(newDangerCommentForm.content)
    try await performNewCommentRequest()
  }
  
  private func performNewCommentRequest() async throws {
    if let postId {
      let body = DangerCommentRequest(from: newDangerCommentForm)
      let _: ForumPostResponse = try await NetworkService.shared.post(
        endpoint: "/dangers/comments/post/\(postId)",
        body: body,
        requiresAuth: true
      )
    }
  }
}
