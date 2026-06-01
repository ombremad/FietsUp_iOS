//
//  ForumPostComponent.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 17/05/2026.
//

import SwiftUI

struct ForumPostComponent: View {
  let post: ForumPostResponse
  let onLike: () -> Void
  let onFav: () -> Void
  let onReport: () -> Void
  let onAnswer: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      authorSection
      postSection
      ForumButtonSection(
        likeCount: post.likeCount,
        isLiked: post.likedByUser,
        isFaved: post.favedByUser,
        onLike: onLike,
        onFav: onFav,
        onReport: onReport,
        onAnswer: onAnswer
      )
    }
    .font(.body)
    .foregroundStyle(Color.Text.primary)
  }
  
  private var authorSection: some View {
    UserPublicCard(
      user: post.user,
      date: post.creationDate,
      size: .big
    )
  }
  
  private var postSection: some View {
    VStack(alignment: .leading, spacing: 24) {
      Text(post.title)
        .font(.title2)
        .multilineTextAlignment(.leading)
      Text(post.content)
    }
  }  
}

#Preview {
  ForumPostComponent(
    post: ForumPostResponse(
      id: UUID(),
      title: "Qui pour aller se balader les dimanches à Toulouse ?",
      content: """
Coucou tout le monde ! Je débute en ville, et j’aimerais trouver des partenaires de vélo avec qui aller faire des promenades faciles les prochaines semaines, au moins le temps de m’habituer.

Évidemment, le but sera d’apprendre, chacun·e à son rythme ! Et pourquoi pas d’accueillir encore plus de débutants quand je me sentirai un peu plus à l’aise moi-même ;-) 

Alors ? On s’organise les Toulousain·es sur·es ??
""",
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
      favedByUser: false,
      comments: []
    ),
    onLike: {},
    onFav: {},
    onReport: {},
    onAnswer: {}
  )
  .padding()
}
