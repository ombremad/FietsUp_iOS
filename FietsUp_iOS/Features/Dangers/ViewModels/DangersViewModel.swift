//
//  DangersViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 08/06/2026.
//

import Foundation
import CoreLocation

@Observable
final class DangersViewModel {
  var isLoading: Bool = false
  var dangerPosts: [DangerPostResponse] = []
  
  // location related values
  private let locationService = LocationService.shared
  var hasLocation: Bool { latitude != nil && longitude != nil }
  var latitude: Double? { locationService.latitude }
  var longitude: Double? { locationService.longitude }
  var locationStatus: CLAuthorizationStatus { locationService.authorizationStatus }
  
  var isNewDangerPostSheetPresented = false

  func load() async {
    isLoading = true
    defer { isLoading = false }
    
    locationService.requestLocation()
    
    do {
      try await performFetchDangerPosts()
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func performFetchDangerPosts() async throws {
    if let latitude, let longitude {
      do {
        let response: [DangerPostResponse] = try await NetworkService.shared.get(
          endpoint: "/dangers/posts/near/?latitude=\(latitude)&longitude=\(longitude)",
          requiresAuth: true
        )
        dangerPosts = response
      } catch {
        ErrorService.shared.show(error)
      }
    }
  }
}
