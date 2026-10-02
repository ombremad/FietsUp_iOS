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
  
  var metadata: PageMetadata = Defaults.pagination.activities.metadata

  var activities: [ActivityResponse] = []

  func load() async {
    isLoading = true
    defer { isLoading = false }

    do {
      try await refreshActivities()
    } catch {
      ErrorService.shared.show(error)
    }
  }

  func goToPage(_ page: Int) async {
    guard !isLoading, page <= metadata.pageCount, page > 0, page != metadata.page else { return }

    isLoading = true
    defer { isLoading = false }

    let previousPage = metadata.page
    metadata.page = page

    do {
      try await refreshActivities()
    } catch {
      metadata.page = previousPage
      ErrorService.shared.show(error)
    }
  }

  func goToNextPage() async {
    await goToPage(metadata.page + 1)
  }

  func goToPreviousPage() async {
    await goToPage(metadata.page - 1)
  }

  private func refreshActivities() async throws {
    let response = try await performFetchActivities()
    metadata = response.metadata
    activities = response.items
  }

  private func performFetchActivities() async throws -> Page<ActivityResponse> {
    return try await NetworkService.shared.get(
      endpoint: "/activities?page=\(metadata.page)&per=\(metadata.per)",
      requiresAuth: true
    )
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
      try await refreshActivities()
      if activities.isEmpty && metadata.page > 1 {
        metadata.page -= 1
        try await refreshActivities()
      }
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func updateLocalUserElapsedDistance(distance: Int) throws {
    auth.currentUser?.totalElapsedDistance += distance
  }
}
