//
//  UserCardBig.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 12/05/2026.
//

import SwiftUI

struct UserCardBig: View {
  let user: User
  
  init(_ user: User) {
    self.user = user
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: Defaults.spacing.vertical.medium) {
      
      HStack {
        VStack(alignment: .leading, spacing: Defaults.spacing.vertical.small) {
          Text(user.nickname)
            .font(.title3)
            .foregroundStyle(Color.Text.primary)
          if let bio = user.bio {
            Text(bio)
              .font(.body)
              .lineLimit(4)
          }
        }
        Spacer()
        BikeAvatar(user.cycle)
          .frame(width: 100, height: 60)
      }
      
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(Color.Surface.divider)
      
      HStack {
        
        HStack(spacing: Defaults.spacing.horizontal.xsmall) {
          Image(systemName: "point.topleft.down.to.point.bottomright.curvepath")
          Text(metersToFormattedKilometers(user.totalElapsedDistance))
            .bold()
            .contentTransition(.numericText())
            .animation(.interactiveSpring(), value: user.totalElapsedDistance)
          Text("common.unit.km")
        }
        Spacer()
        HStack(spacing: Defaults.spacing.horizontal.xsmall) {
          Image(systemName: "calendar")
          Text(user.daysSinceSignup.description)
            .bold()
          Text(user.daysSinceSignup <= 1 ? "user.card.day" : "user.card.days")
        }
        Spacer()
        HStack(spacing: Defaults.spacing.horizontal.xsmall) {
          Text("user.card.streak").textCase(.uppercase)
          Image(systemName: "bolt.fill")
          Text(user.streak.description)
            .bold()
            .contentTransition(.numericText())
            .animation(.interactiveSpring(), value: user.streak)
        }
        .padding(.horizontal, Defaults.padding.xsmall)
        .foregroundStyle(Color.Text.Contrasted.primary)
        .background(Color.Button.primary)
        .clipShape(RoundedRectangle(cornerRadius: Defaults.radius.regular))
        
      }
      .font(.caption2)
      
    }
    .foregroundStyle(Color.Text.secondary)
    .padding(Defaults.padding.medium)
    .background(Color.Surface.primary)
    .clipShape(RoundedRectangle(cornerRadius: Defaults.radius.large))
  }
}

#Preview {
  UserCardBig(.placeholder)
  .padding()
}
