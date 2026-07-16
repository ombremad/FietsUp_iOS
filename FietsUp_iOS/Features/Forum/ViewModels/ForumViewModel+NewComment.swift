//
//  ForumViewModel+NewComment.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 16/07/2026.
//

import Foundation

extension ForumViewModel {
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
      await refreshCategory()
      await refreshCategories()
      
      isNewCommentSheetPresented = false
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func performNewCommentRequest() async throws {
    guard let post else { return }
    
    let body = ForumCommentRequest(from: newCommentForm)
    let _: ForumCommentResponse = try await NetworkService.shared.post(
      endpoint: "/forum/comments/post/\(post.id)",
      body: body,
      requiresAuth: true
    )
  }
}
