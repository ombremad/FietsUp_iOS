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
  var isDiscardAlertPresented: Bool = false
  private let auth = AuthService.shared
  
  private let initialForm: NewActivityForm
  var newActivityForm: NewActivityForm
  struct NewActivityForm: Equatable {
    var startDate: Date = Date.now
    var endDate: Date = Date.now
    var distance: Int = 0
  }
  
  var hasChanges: Bool { newActivityForm != initialForm }
  
  init() {
    let form = NewActivityForm()
    initialForm = form
    newActivityForm = form
  }
  
  func requestCancel() -> Bool {
    if hasChanges { isDiscardAlertPresented = true }
    return !hasChanges
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
      try updateLocalUser(distance: response.distance, streakUpdated: response.streakUpdated)
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func updateLocalUser(distance: Int, streakUpdated: Bool? = nil) throws {
    guard let current = auth.currentUser else { return }
    current.totalElapsedDistance += distance
    if streakUpdated == true {
      let newStreak = current.streak + 1
      current.streak = newStreak
      auth.lastKnownStreak = newStreak
    }
  }
}
