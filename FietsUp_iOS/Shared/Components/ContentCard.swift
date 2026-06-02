//
//  ForumPostCard.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/05/2026.
//

import SwiftUI

struct ContentCard: View {
  let item: ContentCardItem
  init(_ item: ContentCardItem) { self.item = item }
  
  var body: some View {
    VStack(spacing: 12) {
      topSection
      divider
      footer
    }
    .padding(.horizontal, 24)
    .padding(.vertical, 20)
    .font(.body)
    .background(Color.Surface.primary)
    .foregroundStyle(Color.Text.primary)
    .frame(maxWidth: .infinity)
    .clipShape(RoundedRectangle(cornerRadius: 18))
  }
  
  private var topSection: some View {
    HStack(spacing: 12) {
      VStack(alignment: .leading, spacing: 12) {
        authorRow
        titleAndContent
      }
      
      Spacer()
      
      Image(systemName: "chevron.compact.forward")
        .foregroundStyle(Color.Text.tertiary)
    }
  }
  
  @ViewBuilder
  private var authorRow: some View {
    if let user = item.author {
      HStack(spacing: 4) {
        Image(systemName: "person")
        Text(user.nickname)
      }
      .font(.caption2)
      .foregroundStyle(Color.Text.secondary)
      .lineLimit(1)
    }
  }
  
  private var titleAndContent: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text(item.title)
        .font(.title3)
        .lineLimit(2)
      
      Text(item.content)
        .foregroundStyle(Color.Text.secondary)
        .multilineTextAlignment(.leading)
        .lineLimit(item is ForumCategoryResponse ? 2 : 3)
    }
  }
  
  private var divider: some View {
    Rectangle()
      .frame(height: 1)
      .foregroundStyle(Color.Surface.divider)
  }
  
  private var footer: some View {
    HStack {
      if let lastActivityDate = item.lastActivityDate {
        HStack(spacing: 4) {
          Image(systemName: "calendar")
          Text(AttributedString(localized: "forum.lastActive **\(formattedElapsedTime(lastActivityDate))**"))
          }
      }
      
      Spacer()
      
      HStack(spacing: 4) {
        Image(systemName: "bubble.right")
        if item is ForumPostShortResponse {
          Text(AttributedString(localized: "forum.answers **\(item.totalReplies)**"))
        }
        if item is ForumCategoryResponse {
          Text(AttributedString(localized: "forum.discussionsActive **\(item.totalReplies)**"))
        }
      }
    }
    .font(.caption2)
    .foregroundStyle(Color.Text.secondary)
    .lineLimit(1)
  }
}

#Preview {
  VStack(spacing: 12) {
    ContentCard(
      ForumPostShortResponse(
        id: UUID(),
        user: UserShortResponse(
          id: UUID(),
          nickname: "jean_pierre",
          streak: 6
        ),
        title: "Vélo cargo : oui ou non ?",
        content: "Faut-il craquer ? Même à des sommes indécentes (plus de 3000 euros !!?). Assistance électrique ou non ? Vos avis ! C'est très important merci",
        totalComments: 3,
        lastActivityDate: Date(timeIntervalSinceNow: -10000),
      )
    )
    ContentCard(
      ForumCategoryResponse(
        id: UUID(),
        name: "Catégorie",
        details: "Le coin de machin truc",
        totalPosts: 2,
        lastActivityDate: Date(timeIntervalSinceNow: -10000),
      )
    )
  }
  .padding()
}
