//
//  DangersViewModel+NewPost.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 16/07/2026.
//

import Foundation

extension DangersViewModel {
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
      try ValidationService.categoryId(newPostForm.categoryId)
      try ValidationService.location(latitude: latitude, longitude: longitude)
      
      try await performNewPostRequest()
      await refreshPosts()
      
      isNewPostSheetPresented = false
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func performNewPostRequest() async throws {
    let body = DangerPostRequest(from: newPostForm, latitude: latitude!, longitude: longitude!)
    let _: DangerPostResponse = try await NetworkService.shared.post(
      endpoint: "/dangers/posts/category/\(newPostForm.categoryId!)",
      body: body,
      requiresAuth: true
    )
  }
  
  func getNewPostApproximateLocation() async {
    guard let latitude, let longitude else { return }
    
    do {
      newPostForm.approximateLocation = try await ReverseGeocoder.resolve(latitude: latitude, longitude: longitude)
    } catch {
      ErrorService.shared.show(error)
    }
  }
}
