//
//  PlacesViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 03/06/2026.
//

import Foundation
import CoreLocation

@Observable
final class PlacesViewModel {
  var isLoading: Bool = false
  var isPlacesSheetPresented = false
  
  private let locationService = LocationService.shared
  var latitude: Double? { locationService.latitude }
  var longitude: Double? { locationService.longitude }
  var locationStatus: CLAuthorizationStatus { locationService.authorizationStatus }
  
  var categories: [PlaceCategoryResponse] = []
  var placesNearby: [PlaceResponse] = []
  
  func load() async {
    locationService.requestLocation()
    if categories.isEmpty { await performFetchCategories() }
    if placesNearby.isEmpty { await performFetchPlaces() }
    
    Task {
      try? await Task.sleep(for: .seconds(0.5))
      isPlacesSheetPresented = true
    }
  }
  
  private func performFetchCategories() async {
    do {
      let response: [PlaceCategoryResponse] = try await NetworkService.shared.get(
        endpoint: "/places/categories",
        requiresAuth: true
      )
      categories = response
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func performFetchPlaces() async {
    do {
      let response: [PlaceResponse] = try await NetworkService.shared.get(
        // TODO: continue
      )
    }
  }
}
