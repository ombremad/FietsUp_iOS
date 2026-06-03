//
//  ButtonBar.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 17/05/2026.
//

import SwiftUI

struct ForumButtonSection: View {
  let likeCount: Int
  let isLiked: Bool
  let isFaved: Bool
  let onLike: () -> Void
  let onFav: () -> Void
  let onReport: () -> Void
  let onAnswer: () -> Void
  let isLoading: Bool

  var body: some View {
    HStack(spacing: 12) {
      likeButton
      favButton
      reportButton
      Spacer()
      answerButton
    }
  }
  
  private var likeButton: some View {
    Button { onLike() } label: {
      HStack {
        Image(systemName: "hand.thumbsup")
        Text(likeCount.description)
      }
    }
    .buttonStyle(AppForumButton(isActive: isLiked))
    .disabled(isLoading)
  }
  
  private var favButton: some View {
    Button { onFav() } label: {
      Image(systemName: "star")
    }
    .buttonStyle(AppForumButton(isActive: isFaved))
    .disabled(isLoading)
  }
  
  private var reportButton: some View {
    Button { onReport() } label: {
      Image(systemName: "exclamationmark.triangle")
    }
    .buttonStyle(AppForumButton())
  }
  
  private var answerButton: some View {
    Button { onAnswer() } label: {
      HStack {
        Image(systemName: "arrowshape.turn.up.backward")
        Text("post.answerAction")
      }
    }
    .buttonStyle(AppForumButton())
  }
}

#Preview {
  ForumButtonSection(
    likeCount: 32,
    isLiked: true,
    isFaved: false,
    onLike: { },
    onFav:  { },
    onReport: { },
    onAnswer: { },
    isLoading: false
  ).padding()
}
