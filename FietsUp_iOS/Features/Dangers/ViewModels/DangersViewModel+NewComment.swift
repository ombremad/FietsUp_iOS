//
//  DangersViewModel+NewComment.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 16/07/2026.
//

import Foundation

extension DangersViewModel {
  func newComment() {
    newCommentForm = .init()
    isNewCommentSheetPresented = true
  }
  
  func submitComment() async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      try ValidationService.content(newCommentForm.content)
      try await performNewCommentRequest()
      await refreshPost()
      await refreshPosts()
      
      isNewCommentSheetPresented = false
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func performNewCommentRequest() async throws {
    guard let post else { return }
    
    let body = DangerCommentRequest(from: newCommentForm)
    let _: ForumPostResponse = try await NetworkService.shared.post(
      endpoint: "/dangers/comments/post/\(post.id)",
      body: body,
      requiresAuth: true
    )
  }
}
