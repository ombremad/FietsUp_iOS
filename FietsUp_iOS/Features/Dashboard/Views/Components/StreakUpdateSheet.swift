//
//  StreakUpdateSheet.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 01/06/2026.
//

import SwiftUI

struct StreakUpdateSheet: View {
  private let auth = AuthService.shared
  @Environment(\.dismiss) private var dismiss

  @State var streak: Int
  @State var isImproved: Bool
  
  init(streak: Int, lastKnownStreak: Int) {
    self.isImproved = streak > 0
    self.streak = (streak == 0) ? lastKnownStreak : (streak - 1)
  }
  
  var body: some View {
    VStack {
      VStack(spacing: Defaults.spacing.vertical.large) {
        Spacer()
        HStack(spacing: Defaults.spacing.horizontal.large) {
          Image(systemName: "bolt.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(Color.Text.Accent.primary)
            .frame(height: 60)
            .offset(y: 2)
          Text(streak.description)
            .font(.bigStreak)
            .contentTransition(.numericText())
            .animation(.spring.delay(0.5), value: streak)
        }
        
        if isImproved {
          VStack(spacing: 8) {
            Text("streakSheet.streakImproved.title")
              .font(.title2)
            Text("streakSheet.streakImproved.description")
          }
        } else {
          VStack(spacing: 8) {
            Text("streakSheet.streakReset.title")
              .font(.title2)
            Text("streakSheet.streakReset.description")
          }
        }
        
        Spacer()
      }
      .overlay(alignment: .bottom) {
        Button("common.ok") { dismiss() }
          .buttonStyle(AppButton(width: .full))
          .padding(.bottom, Defaults.padding.medium)
      }
      .padding()
      .multilineTextAlignment(.center)
      .frame(maxWidth: .infinity)
      
      .onAppear {
        if isImproved {
          streak += 1
        } else {
          streak = 0
        }
      }
    }
    
    .background(Color.Surface.Datasheet.primary).ignoresSafeArea()
    .foregroundStyle(Color.Text.Contrasted.primary)
    .presentationDetents([.large])
    .presentationDragIndicator(.visible)
  }
}

#Preview {
  StreakUpdateSheet(streak: 0, lastKnownStreak: 2)
}
