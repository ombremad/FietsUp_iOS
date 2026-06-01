//
//  DashboardViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 11/05/2026.
//

import SwiftUI

@Observable
final class DashboardViewModel {
  var isLoading: Bool = false

  var isNewActivitySheetPresented: Bool = false
  var isStreakSheetPresented: Bool = false
  
  func load() async {
    isLoading = true
    defer { isLoading = false }
    
    // TODO: dashboard data fetching
    // await fetchDashboard()
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
}
