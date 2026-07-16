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
  let size: ComponentSize
  
  @State var isUserSheetPresented: Bool = false
  
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
    .padding(.vertical, size == .big ? Defaults.padding.small : Defaults.padding.xsmall)
    .padding(.horizontal, Defaults.padding.medium)
    .font(.body)
    .foregroundStyle(Color.Text.primary)
    .background(Color.Surface.primary)
    .frame(maxWidth: .infinity)
    .clipShape(RoundedRectangle(cornerRadius: Defaults.radius.large))
    .onTapGesture {
      isUserSheetPresented.toggle()
    }
    
    .appSheet(isPresented: $isUserSheetPresented) {
      UserPublicSheet(user)
    }
  }
  
  private var avatarSection: some View {
    BikeAvatar(Cycle(from: user))
      .frame(
        width: size == .big ? Defaults.bikeAvatar.big.width : Defaults.bikeAvatar.small.width,
        height: size == .big ? Defaults.bikeAvatar.big.height : Defaults.bikeAvatar.small.height,
      )
  }
  
  private var authorSection: some View {
    HStack {
      Text(user.nickname).bold()
        .lineLimit(1)
      streakPill
    }
  }
  
  private var dateSection: some View {
    Text(date.formatted(date: .abbreviated, time: .shortened))
      .font(.caption2)
      .foregroundStyle(Color.Text.secondary)
  }
  
  private var streakPill: some View {
    HStack(spacing: Defaults.spacing.horizontal.xsmall) {
      Image(systemName: "bolt.fill")
      Text(user.streak.description)
    }
    .padding(.horizontal, Defaults.padding.xsmall)
    .padding(.vertical, Defaults.padding.xxsmall)
    .font(.caption)
    .foregroundStyle(Color.white)
    .background(Color.accent)
    .clipShape(RoundedRectangle(cornerRadius: Defaults.radius.large))
  }
}

#Preview {
  VStack(spacing: Defaults.spacing.vertical.medium) {
    UserPublicCard.bigPlaceholder
    UserPublicCard.smallPlaceholder
  }
  .padding()
}
