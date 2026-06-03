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
  var isSinglePlaceSheetPresented = false
  
  private let locationService = LocationService.shared
  var hasLocation: Bool { latitude != nil && longitude != nil }
  var latitude: Double? { locationService.latitude }
  var longitude: Double? { locationService.longitude }
  var locationStatus: CLAuthorizationStatus { locationService.authorizationStatus }
  
  var categories: [PlaceCategoryResponse] = []
  var placesNearby: [PlaceResponse] = []
  var selectedPlace: PlaceResponse? = nil
  
  func load() async {
    locationService.requestLocation()
    if categories.isEmpty { await performFetchCategories() }
    
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
  
  func performFetchPlaces() async {
    if let latitude, let longitude {
      do {
        print("Latitude: \(latitude), Longitude: \(longitude)")
        let response: [PlaceResponse] = try await NetworkService.shared.get(
          endpoint: "/places/near/?latitude=\(latitude)&longitude=\(longitude)",
          requiresAuth: true
        )
        placesNearby = response
      } catch {
        ErrorService.shared.show(error)
      }
    }
  }
  
  func displayPlace(_ place: PlaceResponse) {
    selectedPlace = place
    isSinglePlaceSheetPresented = true
  }
}
