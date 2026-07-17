//
//  ForumViewModel+NewPost.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 16/07/2026.
//

import Foundation

extension ForumViewModel {
  func newPost() {
    newPostForm = .init()
    isNewPostSheetPresented = true
  }
  
  func submitPost() async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      try ValidationService.title(newPostForm.title)
      try ValidationService.content(newPostForm.content)
      
      try await performNewPostRequest()
      await refreshCategory()
      await refreshCategories()
      
      isNewPostSheetPresented = false
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func performNewPostRequest() async throws {
    guard let category else { return }

    let body = ForumPostRequest(from: newPostForm)
    let _: ForumPostPaginatedResponse = try await NetworkService.shared.post(
      endpoint: "/forum/posts/category/\(category.id)",
        body: body,
        requiresAuth: true
      )
  }
}
