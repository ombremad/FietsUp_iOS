//
//  UserPublicSheet.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 17/05/2026.
//

import SwiftUI

struct UserPublicSheet: View {
  var user: UserPublicResponse
  init(_ user: UserPublicResponse) { self.user = user }
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 36) {
        userHeader
        avatar
        stats
      }
      .padding(.top, 32)
      .padding(.horizontal)
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .presentationBackground(Color.Surface.background)
    .presentationDragIndicator(.visible)
    .presentationDetents([.fraction(0.7), .large])
  }
  
  private var userHeader: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack {
        Text(user.nickname)
          .font(.title)
        Spacer()
        streakPill
      }
      biography
    }
  }
    
  private var avatar: some View {
    BikeAvatar()
      .frame(height: 200)
  }
  
  private var stats: some View {
    VStack(alignment: .leading, spacing: 16) {
      statsComponent(
        name: "user.sheet.totalElapsedDistance",
        icon: "point.topleft.down.to.point.bottomright.curvepath",
        value: metersToFormattedKilometers(user.totalElapsedDistance),
        unit: "common.unit.km"
      )
      statsComponent(
        name: "user.sheet.registeredFor",
        icon: "calendar",
        value: user.daysSinceSignup.description,
        unit: "common.unit.days"
      )
    }
  }
  
  @ViewBuilder
  private var biography: some View {
    if let bio = user.bio {
      Text(bio)
        .font(.callout)
        .foregroundStyle(Color.Text.secondary)
        .multilineTextAlignment(.leading)
    }
  }
  
  private var streakPill: some View {
    HStack {
      Image(systemName: "bolt.fill")
      Text(user.streak.description)
        .font(.data2).bold()
    }
    .font(.body)
    .padding(.horizontal, 16)
    .padding(.vertical, 6)
    .foregroundStyle(.white)
    .background(Color.Button.primary)
    .clipShape(Capsule())
  }
  
  private func statsComponent(
    name: LocalizedStringKey,
    icon: String,
    value: String,
    unit: LocalizedStringKey
  ) -> some View {
    HStack {
      Image(systemName: icon)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 40, height: 32)
      VStack(alignment: .leading) {
        Text(name)
          .font(.body)
        HStack(spacing: 6) {
          Text(value.description)
            .font(.data2)
            .bold()
          Text(unit)
            .font(.data2)
        }
      }
    }
    .foregroundStyle(Color.Text.secondary)
  }
}

#Preview {
  UserPublicSheet(UserPublicResponse.placeholder)
}
