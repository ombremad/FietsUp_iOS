//
//  ForumPostComponent.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 17/05/2026.
//

import SwiftUI

struct ContentComponent: View {
  let size: ComponentSize
  let title: String?
  let content: String
  let date: Date
  let user: UserPublicResponse
  
  init(size: ComponentSize, title: String? = nil, content: String, date: Date, user: UserPublicResponse) {
    self.title = title
    self.content = content
    self.date = date
    self.size = size
    self.user = user
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      authorSection
      contentSection
    }
    .font(.body)
    .foregroundStyle(Color.Text.primary)
  }
  
  private var authorSection: some View {
    UserPublicCard(
      user: user,
      date: date,
      size: size
    )
  }
  
  private var contentSection: some View {
    VStack(alignment: .leading, spacing: 24) {
      if let title {
        Text(title)
          .font(.title2)
          .multilineTextAlignment(.leading)
      }
      Text(content)
    }
  }  
}

#Preview {
  ContentComponent(
    size: .big,
    title: "Qui pour aller se balader les dimanches à Toulouse ?",
    content: """
Coucou tout le monde ! Je débute en ville, et j’aimerais trouver des partenaires de vélo avec qui aller faire des promenades faciles les prochaines semaines, au moins le temps de m’habituer.

Évidemment, le but sera d’apprendre, chacun·e à son rythme ! Et pourquoi pas d’accueillir encore plus de débutants quand je me sentirai un peu plus à l’aise moi-même ;-) 

Alors ? On s’organise les Toulousain·es sur·es ??
""",
    date: Date.now,
    user: UserPublicResponse(
      id: UUID(),
      nickname: "Veliste_du_31",
      streak: 3,
      daysSinceSignup: 128,
      totalElapsedDistance: 1_200_000,
      bio: nil,
    ),
  )
  .padding()
}
