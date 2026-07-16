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
    VStack(spacing: Defaults.spacing.vertical.medium) {
      topSection
      divider
      footer
    }
    .padding(Defaults.padding.medium)
    .font(.body)
    .background(Color.Surface.primary)
    .foregroundStyle(Color.Text.primary)
    .frame(maxWidth: .infinity)
    .clipShape(RoundedRectangle(cornerRadius: Defaults.radius.large))
  }
  
  private var topSection: some View {
    HStack(spacing: Defaults.spacing.horizontal.medium) {
      VStack(alignment: .leading, spacing: Defaults.spacing.vertical.medium) {
        flairRows
        titleAndContent
      }
      
      Spacer()
      
      Image(systemName: "chevron.compact.forward")
        .foregroundStyle(Color.Text.tertiary)
    }
  }
  
  @ViewBuilder
  private var flairRows: some View {
    if !flairs.isEmpty {
      VStack(alignment: .leading, spacing: Defaults.spacing.vertical.xsmall) {
        ForEach(flairs, id: \.self) { flair in
          HStack(spacing: Defaults.spacing.horizontal.xsmall) {
            Image(systemName: flair.iconName)
              .frame(width: 20)
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
    VStack(alignment: .leading, spacing: Defaults.spacing.vertical.small) {
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
        HStack(spacing: Defaults.spacing.horizontal.xsmall) {
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
      
      HStack(spacing: Defaults.spacing.horizontal.xsmall) {
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
    VStack(spacing: Defaults.spacing.vertical.medium) {
      ContentCard.forumCategoryPlaceholder
      ContentCard.forumPostPlaceholder
      ContentCard.placePlaceholder
      ContentCard.dangerPostPlaceholder
    }
    .padding()
  }
}
