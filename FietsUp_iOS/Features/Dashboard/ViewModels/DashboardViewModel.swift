//
//  DashboardViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 11/05/2026.
//

import SwiftUI

@Observable
final class DashboardViewModel {
  private let auth = AuthService.shared
  
  var isLoading: Bool = false
  var isNewActivitySheetPresented: Bool = false
  var isStreakSheetPresented: Bool = false
  
  var lastKnownStreakForSheet: Int = 0
  
  func load() async {
    isLoading = true
    defer { isLoading = false }
    
    await auth.restoreSession()
    checkAndUpdateStreak()
  }
  
  private func fetchDashboard() async {
    do {
      let _: DashboardResponse = try await NetworkService.shared.get(
        endpoint: "/dashboard",
        requiresAuth: true,
      )
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func checkAndUpdateStreak() {
    guard let current = auth.currentUser else { return }
    let lastKnownStreak = auth.lastKnownStreak
    if current.streak == 0 && lastKnownStreak > 0 {
      self.lastKnownStreakForSheet = lastKnownStreak
      isStreakSheetPresented = true
    }
    auth.lastKnownStreak = current.streak
  }
}
