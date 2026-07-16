//
//  SplitParagraphs.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 08/06/2026.
//

import SwiftUI

func splitParagraphs(_ content: String) -> some View {
  var paragraphs: [String] {
    content
    .components(separatedBy: .newlines)
    .filter { !$0.isEmpty }
  }
  
  return VStack(alignment: .leading, spacing: Defaults.spacing.vertical.medium) {
    ForEach(Array(paragraphs.enumerated()), id: \.offset) { _, paragraph in
      Text(paragraph)
    }
  }
}
