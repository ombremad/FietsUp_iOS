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
    VStack(alignment: .leading, spacing: 16) {
      
      HStack {
        VStack(alignment: .leading, spacing: 8) {
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
        BikeAvatar()
          .frame(width: 100, height: 60)
      }
      
      Rectangle()
        .frame(height: 1)
        .foregroundStyle(Color.Surface.divider)
      
      HStack {
        
        HStack(spacing: 3) {
          Image(systemName: "point.topleft.down.to.point.bottomright.curvepath")
          Text((Double(user.totalElapsedDistance) / 1000).formatted(.number.precision(.fractionLength(0...2))))
            .bold()
          Text("common.unit.km")
        }
        Spacer()
        HStack(spacing: 3) {
          Image(systemName: "calendar")
          Text(user.daysSinceSignup.description)
            .bold()
          Text(user.daysSinceSignup <= 1 ? "user.card.day" : "user.card.days")
        }
        Spacer()
        HStack(spacing: 3) {
          Text("user.card.streak").textCase(.uppercase)
          Image(systemName: "bolt.fill")
          Text(user.streak.description)
            .bold()
        }
        .padding(.horizontal, 6)
        .foregroundStyle(Color.Text.Contrasted.primary)
        .background(Color.Button.primary)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
      }
      .font(.caption2)
      
    }
    .foregroundStyle(Color.Text.secondary)
    .padding(24)
    .background(Color.Surface.primary)
    .clipShape(RoundedRectangle(cornerRadius: 18))
  }
}

#Preview {
  UserCardBig(User(with: .init(
    firstName: "Jeanne",
    lastName: "Dubois",
    nickname: "Velocipede_2000",
    email: "velocipede2000@example.com",
    bio: "Je fais du vélo au milieu des voitures, et c'est ma grande joie",
    streak: 3,
    daysSinceSignup: 128,
    totalElapsedDistance: 1200000
  )))
  .padding()
}
