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
  
  let flairs: [CardFlair]
  let title: String?
  let content: String?
  let footerData: Int
  let date: Date?
  
  init(
    contentType: ContentType,
    flairs: [CardFlair] = [],
    title: String? = nil,
    content: String? = nil,
    footerData: Int,
    date: Date? = nil
  ) {
    self.contentType = contentType
    self.flairs = flairs
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
    if !flairs.isEmpty {
      VStack(alignment: .leading, spacing: 2) {
        ForEach(flairs, id: \.self) { flair in
          HStack(spacing: 4) {
            Image(systemName: flair.iconName)
            Text(flair.name)
          }
        }
        .font(.caption2)
        .foregroundStyle(Color.Text.secondary)
        .lineLimit(1)
      }
    }
  }
  
  @ViewBuilder
  private var titleAndContent: some View {
    VStack(alignment: .leading, spacing: 6) {
      if let title {
        Text(title)
          .font(.title3)
          .lineLimit(2)
      }
      
      if let content {
        Text(content)
          .foregroundStyle(Color.Text.secondary)
          .multilineTextAlignment(.leading)
          .lineLimit(3)
      }
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
            Text(AttributedString(localized: "place.distanceInMeters **\(footerData)**"))
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
        flairs: [CardFlair(name: "Veliste_du_31", iconName: "person.fill")],
        title: "Vélo cargo : oui ou non ?",
        content: """
Faut-il craquer ? Même à des sommes indécentes (plus de 3000 euros !!?). Assistance électrique ou non ? Vos avis ! C'est très important merci
""",
        footerData: 3,
        date: Date(timeIntervalSinceNow: -10000)
      )
      ContentCard(
        contentType: .place,
        flairs: [
          CardFlair(name: "Point self-service", iconName: "screwdriver"),
          CardFlair(name:" Borne libre service", iconName: "point.topright.arrow.triangle.backward.to.point.bottomleft.scurvepath.fill")
        ],
        title: "Borne de gonflage",
        content: "En plein air, accessible 24h/24",
        footerData: 300,
        date: Date(timeIntervalSinceNow: -10000)
      )
      ContentCard(
        contentType: .dangerPost,
        flairs: [CardFlair(name: "Véhicule gênant", iconName: "car.top.radiowaves.rear.left.car.top.front")],
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
