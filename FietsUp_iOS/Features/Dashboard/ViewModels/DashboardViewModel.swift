//
//  DashboardViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 11/05/2026.
//

import Foundation

@Observable
final class DashboardViewModel {
  var isLoading: Bool = false
  
  func load() async {
    isLoading = true
    defer { isLoading = false }
    await fetchDashboard()
  }
  
  private func fetchDashboard() async {
    do {
      let response: DashboardResponse = try await NetworkService.shared.get(
        endpoint: "/dashboard",
        requiresAuth: true,
      )
      // TODO: do something with dashboard data eventually
    } catch {
      ErrorService.shared.show(error)
    }
  }
}
