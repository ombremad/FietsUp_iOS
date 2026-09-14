//
//  RatingStars.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 14/09/2026.
//

import SwiftUI

struct RatingStars: View {
  let type: RatingStarsType
  let note: Double
  let maxNote: Int = 5
  
  enum RatingStarsType {
    case small, tag
  }
  
  init(type: RatingStarsType, note: Double?) {
    self.type = type
    self.note = note ?? 0
  }
    
  @ViewBuilder private var stars: some View {
    HStack(spacing: 0) {
      ForEach(0..<maxNote, id: \.self) { _ in
        Image(systemName: "star")
      }
    }
    .overlay(alignment: .leading) {
      GeometryReader { geo in
        HStack(spacing: 0) {
          ForEach(0..<maxNote, id: \.self) { _ in
            Image(systemName: "star.fill")
          }
        }
        .mask(alignment: .leading) {
          Rectangle()
            .frame(width: geo.size.width * CGFloat(note / Double(maxNote)), alignment: .leading)
        }
      }
    }
    .foregroundStyle(.yellow)
    .drawingGroup()
  }
  
  @ViewBuilder private var noteLabel: some View {
    Text(note.description)
  }
  
  var body: some View {
    HStack {
      if type == .small {
        stars
        noteLabel
      } else if type == .tag {
        HStack {
          stars
          noteLabel
        }
        .padding(.horizontal, Defaults.padding.medium)
        .padding(.vertical, Defaults.padding.xsmall)
        .foregroundStyle(Color.Text.secondary)
        .background(Color.Surface.secondary)
        .clipShape(Capsule())
      }
    }
  }
}

#Preview {
  VStack(spacing: Defaults.spacing.vertical.xlarge) {
    RatingStars(
      type: .small,
      note: 3.14,
    )
    RatingStars(
      type: .tag,
      note: 4.62,
    )
  }
}
