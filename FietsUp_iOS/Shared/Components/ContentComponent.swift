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
    VStack(alignment: .leading, spacing: 16) {
      if let title {
        Text(title)
          .font(.title2)
          .multilineTextAlignment(.leading)
      }
      
      splitParagraphs(content)
    }
  }  
}

#Preview {
  ContentComponent.bigPlaceholder.padding()
}
