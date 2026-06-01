//
//  StreakUpdateSheet.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 01/06/2026.
//

import SwiftUI

struct StreakUpdateSheet: View {
  @State var streak: Int
  init(_ streak: Int) {
    self.streak = streak - 1
  }

  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    VStack {
      VStack(spacing: 24) {
        Spacer()
        HStack(spacing: 24) {
          Image(systemName: "bolt.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(Color.Text.Accent.primary)
            .frame(height: 60)
            .offset(y: 2)
          Text(streak.description)
            .font(.bigStreak)
            .contentTransition(.numericText())
            .animation(.spring.delay(0.3), value: streak)
        }
        
        VStack(spacing: 8) {
          Text("streakSheet.streakImproved.title")
            .font(.title2)
          Text("streakSheet.streakImproved.description")
        }
        
        Spacer()
      }
      .overlay(alignment: .bottom) {
        Button("common.ok") { dismiss() }
          .buttonStyle(AppButton(width: .full))
          .padding(.bottom, 24)
      }
      .padding()
      .multilineTextAlignment(.center)
      .frame(maxWidth: .infinity)
      
      .onAppear {
        streak += 1
      }
    }
    
    .background(Color.Surface.Datasheet.primary).ignoresSafeArea()
    .foregroundStyle(Color.Text.Contrasted.primary)
    .presentationDetents([.large])
    .presentationDragIndicator(.visible)
  }
}

#Preview {
  StreakUpdateSheet(3)
}
