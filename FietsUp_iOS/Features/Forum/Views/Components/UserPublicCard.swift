//
//  UserPublicCard.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 17/05/2026.
//

import SwiftUI

struct UserPublicCard: View {
  let user: UserPublicResponse
  let date: Date
  let size: UserPublicCardSize
  enum UserPublicCardSize { case big, small }
  
  var body: some View {
    HStack {
      avatarSection

      if size == .big {
        VStack(alignment: .leading) {
          authorSection
          dateSection
        }
        Spacer()
      }
      
      if size == .small {
        authorSection
        Spacer()
        dateSection
      }
      
    }
    .padding(.vertical, size == .big ? 16 : 10)
    .padding(.horizontal, 16)
    .font(.body)
    .foregroundStyle(Color.Text.primary)
    .background(Color.Surface.primary)
    .frame(maxWidth: .infinity)
    .clipShape(RoundedRectangle(cornerRadius: 18))
  }
  
  private var avatarSection: some View {
    BikeAvatar()
      .frame(
        width: size == .big ? 46 : 25,
        height: size == .big ? 30 : 16,
      )
  }
  
  private var authorSection: some View {
    HStack {
      Text(user.nickname).bold()
      streakPill
    }
  }
  
  private var dateSection: some View {
    Text(date.formatted(date: .abbreviated, time: .shortened))
      .font(.caption2)
      .foregroundStyle(Color.Text.secondary)
  }
  
  private var streakPill: some View {
    HStack(spacing: 4) {
      Image(systemName: "bolt.fill")
      Text(user.streak.description)
    }
    .padding(.leading, 8)
    .padding(.trailing, 10)
    .padding(.vertical, 1)
    .font(.caption)
    .foregroundStyle(Color.white)
    .background(Color.accent)
    .clipShape(RoundedRectangle(cornerRadius: 10))
  }
}

#Preview {
  VStack(spacing: 12) {
    UserPublicCard(
      user: UserPublicResponse(
        id: UUID(),
        nickname: "Veliste_du_31",
        streak: 3
      ),
      date: Date.now,
      size: .big
    )
    UserPublicCard(
      user: UserPublicResponse(
        id: UUID(),
        nickname: "ombremad",
        streak: 12
      ),
      date: Date.now,
      size: .small
    )
  }
  .padding()
}
