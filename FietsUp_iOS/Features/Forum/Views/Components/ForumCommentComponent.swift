//
//  ForumCommentComponent.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 17/05/2026.
//

import SwiftUI

struct ForumCommentComponent: View {
  let comment: ForumCommentResponse
  init(_ comment: ForumCommentResponse) { self.comment = comment }

  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      authorSection
      ForumButtonSection(
        likeCount: comment.likeCount,
        isLiked: comment.likedByUser,
        isFaved: comment.favedByUser
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
}

#Preview {
  ForumCommentComponent(
    ForumCommentResponse(
      id: UUID(),
      content: "Moi ça m'intéresse !",
      user: UserPublicResponse(
        id: UUID(),
        nickname: "ombremad",
        streak: 12
      ),
      creationDate: Date.now,
      likeCount: 18,
      likedByUser: true,
      favedByUser: false
    )
  )
  .padding()
}
