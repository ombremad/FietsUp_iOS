//
//  ActivityViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 12/05/2026.
//

import Foundation

@Observable
final class NewActivityViewModel {
  var isLoading: Bool = false
  private let auth = AuthService.shared
  
  var newActivityForm = NewActivityForm()
  struct NewActivityForm {
    var startDate: Date = Date.now
    var endDate: Date = Date.now
    var distance: Int = 0
  }
  
  func submit() async throws {
    isLoading = true
    defer { isLoading = false }
    
    try ValidationService.activityDates(
      start: newActivityForm.startDate,
      end: newActivityForm.endDate
    )
    try ValidationService.distance(newActivityForm.distance)
    try await performNewActivityRequest()
  }
  
  private func performNewActivityRequest() async throws {
    do {
      let body = ActivityRequest(from: newActivityForm)
      let response: ActivityResponse = try await NetworkService.shared.post(
        endpoint: "/activities",
        body: body,
        requiresAuth: true
      )
      try updateLocalUserElapsedDistance(distance: response.distance)
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func updateLocalUserElapsedDistance(distance: Int) throws {
    auth.currentUser?.totalElapsedDistance += distance
  }
}
