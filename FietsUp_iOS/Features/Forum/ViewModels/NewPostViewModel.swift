//
//  NewPostViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 01/06/2026.
//

import Foundation

@Observable
final class NewPostViewModel {
  var isLoading: Bool = false
  var categoryId: UUID?
  
  var newPostForm = NewPostForm()
  struct NewPostForm {
    var title: String = ""
    var content: String = ""
  }
  
  func load(categoryId: UUID) {
    self.categoryId = categoryId
  }
  
  func submit() async throws {
    isLoading = true
    defer { isLoading = false }
    
    try ValidationService.title(newPostForm.title)
    try ValidationService.content(newPostForm.content)
    try await performNewPostRequest()
  }
  
  private func performNewPostRequest() async throws {
    if let categoryId {
      do {
        let body = ForumPostRequest(from: newPostForm)
        let _: ForumPostResponse = try await NetworkService.shared.post(
          endpoint: "/forum/posts/category/\(categoryId)",
          body: body,
          requiresAuth: true
        )
      } catch {
        ErrorService.shared.show(error)
      }
    }
  }
}
