//
//  ForumPostCard.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/05/2026.
//

import SwiftUI

struct ContentCard: View {
  let contentType: ContentType
  enum ContentType {
    case forumPost, forumCategory, place, dangerPost
  }
  
  let flairIcon: String?
  let flairText: String?
  let title: String?
  let content: String
  let footerData: Int
  let date: Date?
  
  init(contentType: ContentType, flairIcon: String? = nil, flairText: String? = nil, title: String? = nil, content: String, footerData: Int, date: Date? = nil) {
    self.contentType = contentType
    self.flairIcon = flairIcon
    self.flairText = flairText
    self.title = title
    self.content = content
    self.footerData = footerData
    self.date = date
  }
  
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
        flairRow
        titleAndContent
      }
      
      Spacer()
      
      Image(systemName: "chevron.compact.forward")
        .foregroundStyle(Color.Text.tertiary)
    }
  }
  
  @ViewBuilder
  private var flairRow: some View {
    if let flairIcon, let flairText {
      HStack(spacing: 4) {
        Image(systemName: flairIcon)
        Text(flairText)
      }
      .font(.caption2)
      .foregroundStyle(Color.Text.secondary)
      .lineLimit(1)
    }
  }
  
  private var titleAndContent: some View {
    VStack(alignment: .leading, spacing: 6) {
      if let title {
        Text(title)
          .font(.title3)
          .lineLimit(2)
      }
      
      Text(content)
        .foregroundStyle(Color.Text.secondary)
        .multilineTextAlignment(.leading)
        .lineLimit(3)
    }
  }
  
  private var divider: some View {
    Rectangle()
      .frame(height: 1)
      .foregroundStyle(Color.Surface.divider)
  }
  
  private var footer: some View {
    HStack {
      if let date {
        HStack(spacing: 4) {
          Image(systemName: "calendar")
          switch contentType {
            case .forumPost, .forumCategory:
              Text(AttributedString(localized: "forum.lastActive **\(formattedElapsedTime(date))**"))
            case .place:
              Text(AttributedString(localized: "place.lastUpdate **\(formattedElapsedTime(date))**"))
            case .dangerPost:
              Text(AttributedString(localized: "danger.signaledAgo **\(formattedElapsedTime(date))**"))
          }
        }
      }
      
      Spacer()
      
      HStack(spacing: 4) {
        switch contentType {
          case .forumPost:
            Image(systemName: "bubble.right")
            Text(AttributedString(localized: "forum.answers **\(footerData)**"))
          case .forumCategory:
            Image(systemName: "bubble.right")
            Text(AttributedString(localized: "forum.discussionsActive **\(footerData)**"))
          case .place, .dangerPost:
            Image(systemName: "signpost.right")
            Text(AttributedString(localized: "place.awayMeters **\(footerData)**"))
        }
      }
    }
    .font(.caption2)
    .foregroundStyle(Color.Text.secondary)
    .lineLimit(1)
  }
}

#Preview {
  ScrollView {
    VStack(spacing: 16) {
      ContentCard(
        contentType: .forumCategory,
        title: "Le coin des débutant·es",
        content: """
Présentation, premiers trajets, appréhensions, bonnes habitudes, conseils...
""",
        footerData: 6,
        date: Date(timeIntervalSinceNow: -10000)
      )
      ContentCard(
        contentType: .forumPost,
        flairIcon: "person.fill",
        flairText: "Veliste_du_31",
        title: "Vélo cargo : oui ou non ?",
        content: """
Faut-il craquer ? Même à des sommes indécentes (plus de 3000 euros !!?). Assistance électrique ou non ? Vos avis ! C'est très important merci
""",
        footerData: 3,
        date: Date(timeIntervalSinceNow: -10000)
      )
      ContentCard(
        contentType: .place,
        flairIcon: "screwdriver",
        flairText: "Point self-service",
        title: "Borne de gonflage",
        content: "En plein air, accessible 24h/24",
        footerData: 300,
        date: Date(timeIntervalSinceNow: -10000)
      )
      ContentCard(
        contentType: .dangerPost,
        flairIcon: "car.top.radiowaves.rear.left.car.top.front",
        flairText: "Véhicule gênant",
        title: "Voiture garée sur la piste cyclable",
        content: """
Quartier Minimes, très dangereux !
Le chauffeur au téléphone s’est arrêté portière ouverte sans même regarder. Il y est toujours garé à l’heure où j’écris ce signalement. Attention, il a également tendance à être agressif, prenez soin de vous.
À l’angle de la pharmacie et de l’entrée du métro.
""",
        footerData: 500,
        date: Date(timeIntervalSinceNow: -10000)
      )
    }
    .padding()
  }
}
