//
//  ForumCategoryRowCard.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 08/07/2026.
//

import SwiftUI

struct ForumCategoryRowCard: View {
  let category: ForumCategoryResponse
  init(_ category: ForumCategoryResponse) {
    self.category = category
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(category.name)
        .font(.body).bold()
        .foregroundStyle(Color.Text.primary)
        .lineLimit(2)
      Text(category.details)
        .font(.callout)
        .lineLimit(4)
    }
  }
}

#Preview {
  NavigationStack {
    Form {
      ForumCategoryRowCard.placeholder
    }
  }
}
