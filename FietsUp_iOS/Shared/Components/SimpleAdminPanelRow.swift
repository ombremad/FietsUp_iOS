//
//  AdminPanelRow.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 10/07/2026.
//

import SwiftUI

struct SimpleAdminPanelRow: View {
  enum Label {
    case localized(LocalizedStringKey)
    case verbatim(String)
    
    var text: Text {
      switch self {
        case .localized(let key): Text(key)
        case .verbatim(let string): Text(verbatim: string)
      }
    }
  }

  let title: Label
  let description: Label?
  let iconName: String?
  
  init(titleLocalized title: LocalizedStringKey, descriptionLocalized description: LocalizedStringKey? = nil, iconName: String? = nil) {
    self.title = .localized(title)
    self.description = description.map { .localized($0) }
    self.iconName = iconName
  }
  
  init(title: String, description: String? = nil, iconName: String? = nil) {
    self.title = .verbatim(title)
    self.description = description.map { .verbatim($0) }
    self.iconName = iconName
  }

  var body: some View {
    HStack {
      if let iconName {
        Image(systemName: iconName)
          .frame(width: 26, height: 20)
          .aspectRatio(contentMode: .fit)
      }
      
      VStack(alignment: .leading) {
        title.text.font(.body).bold()
        if let description {
          description.text.font(.caption2)
        }
      }
      
      Spacer()
    }
    .contentShape(Rectangle())
  }
}

#Preview {
  Form {
    SimpleAdminPanelRow(
      title: Placeholder.ForumCategory.name,
      description: Placeholder.ForumCategory.content,
    )
    SimpleAdminPanelRow(
      title: Placeholder.ForumCategory.name,
      description: Placeholder.ForumCategory.content,
      iconName: "checkmark",
    )
  }
}
