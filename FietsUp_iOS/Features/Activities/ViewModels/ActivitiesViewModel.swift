//
//  ActivityViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 13/05/2026.
//

import SwiftUI

@Observable
final class ActivitiesViewModel {
  var isLoading: Bool = false
  private let auth = AuthService.shared
  
  var activities: [ActivityResponse] = []
  
  func load() async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      try await performFetchActivities()
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func performFetchActivities() async throws {
    let response: [ActivityResponse] = try await NetworkService.shared.get(
      endpoint: "/activities",
      requiresAuth: true
    )
    activities = response
  }
  
  func delete(at offsets: IndexSet) async {
    let toDelete = offsets.map { activities[$0] }
    do {
      for activity in toDelete {
        try await NetworkService.shared.delete(
          endpoint: "/activities/\(activity.id)",
          requiresAuth: true
        )
        try updateLocalUserElapsedDistance(distance: -activity.distance)
      }
      activities.remove(atOffsets: offsets)
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func updateLocalUserElapsedDistance(distance: Int) throws {
    auth.currentUser?.totalElapsedDistance += distance
  }
}
