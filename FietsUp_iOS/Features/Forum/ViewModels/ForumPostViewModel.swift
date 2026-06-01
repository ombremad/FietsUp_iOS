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
  var isLiking: Bool = false
  var isFaving: Bool = false
    
  var id: UUID?
  var post: ForumPostResponse?
  
  func load(id: UUID) async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      self.id = id
      try await performFetchPost()
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  func like() async {
    isLiking = true
    defer { isLiking = false }
    
    guard let current = post else { return }
    
    post = ForumPostResponse(
      id: current.id,
      title: current.title,
      content: current.content,
      user: current.user,
      creationDate: current.creationDate,
      likeCount: current.likedByUser ? current.likeCount - 1 : current.likeCount + 1,
      likedByUser: !current.likedByUser,
      favedByUser: current.favedByUser,
      comments: current.comments
    )
    
    do {
      try await performLike()
    } catch {
      post = current
      ErrorService.shared.show(error)
    }
  }
  
  func fav() async {
    isLiking = true
    defer { isLiking = false }
    
    guard let current = post else { return }
    
    post = ForumPostResponse(
      id: current.id,
      title: current.title,
      content: current.content,
      user: current.user,
      creationDate: current.creationDate,
      likeCount: current.likeCount,
      likedByUser: current.likedByUser,
      favedByUser: !current.favedByUser,
      comments: current.comments
    )

    do {
      try await performFav()
    } catch {
      post = current
      ErrorService.shared.show(error)
    }
  }
  
  private func performFetchPost() async throws {
    if let id = id {
      let response: ForumPostResponse = try await NetworkService.shared.get(
        endpoint: "/forum/posts/\(id)",
        requiresAuth: true
      )
      post = response
    }
  }
  
  private func performLike() async throws {
    if let id = id {
      let response: ForumPostResponse = try await NetworkService.shared.post(
        endpoint: "/forum/posts/\(id)/like",
        requiresAuth: true
      )
      post = response
    }
  }
  
  private func performFav() async throws {
    if let id = id {
      let response: ForumPostResponse = try await NetworkService.shared.post(
        endpoint: "/forum/posts/\(id)/fav",
        requiresAuth: true
      )
      post = response
    }
  }
}
