//
//  ForumCommentComponent.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 17/05/2026.
//

import SwiftUI

struct ForumCommentComponent: View {
  let comment: ForumCommentResponse
  let onLike: () -> Void
  let onFav: () -> Void
  let onReport: () -> Void
  let onAnswer: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      authorSection
      postSection
      ForumButtonSection(
        likeCount: comment.likeCount,
        isLiked: comment.likedByUser,
        isFaved: comment.favedByUser,
        onLike: onLike,
        onFav: onFav,
        onReport: onReport,
        onAnswer: onAnswer,
      )
    }
  }
  
  private var authorSection: some View {
    UserPublicCard(
      user: comment.user,
      date: comment.creationDate,
      size: .small
    )
  }
  
  private var postSection: some View {
    Text(comment.content)
  }
}

#Preview {
  ForumCommentComponent(
    comment: ForumCommentResponse(
      id: UUID(),
      content: "Moi ça m'intéresse !",
      user: UserPublicResponse(
        id: UUID(),
        nickname: "Veliste_du_31",
        streak: 3,
        daysSinceSignup: 128,
        totalElapsedDistance: 1_200_000,
        bio: nil,
      ),
      creationDate: Date.now,
      likeCount: 18,
      likedByUser: true,
      favedByUser: false
    ),
    onLike: {},
    onFav: {},
    onReport: {},
    onAnswer: {}
  )
  .padding()
}
