//
//  PlacesViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 03/06/2026.
//

import SwiftUI
import Foundation
import CoreLocation
import MapKit

@Observable
final class PlacesViewModel {
  // state related values
  var isLoading: Bool = false
  var isPlacesSheetPresented = false
  var isSinglePlaceSheetPresented = false
  var hasActiveSheet: Bool {
    isSinglePlaceSheetPresented || isPlacesSheetPresented
  }
  
  // location related values
  private let locationService = LocationService.shared
  var hasLocation: Bool { latitude != nil && longitude != nil }
  var latitude: Double? { locationService.latitude }
  var longitude: Double? { locationService.longitude }
  var locationStatus: CLAuthorizationStatus { locationService.authorizationStatus }
  var cameraPosition: MapCameraPosition = .automatic
  
  // fixed values for maps settings
  private let zoomedDelta: Double = 0.01
  private let dezoomedDelta: Double = 0.02
  private let sheetOffsetFactor: Double = 0.35

  // places related values
  var categories: [PlaceCategoryResponse] = []
  var placesNearby: [PlaceResponse] = []
  var selectedPlace: PlaceResponse? = nil
  
  // functions
  
  func load() async {
    locationService.requestLocation()
    if categories.isEmpty { await performFetchCategories() }
    centerOnUser()
    
    Task {
      try? await Task.sleep(for: .seconds(0.5))
      isPlacesSheetPresented = true
    }
  }
  
  func centerOnUser() {
    if let latitude, let longitude {
      centerMapOn(latitude: latitude, longitude: longitude, delta: dezoomedDelta)
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
    centerMapOn(latitude: place.latitude, longitude: place.longitude, delta: zoomedDelta)
    showSinglePlaceSheet()
  }
  
  func showSinglePlaceSheet() {
    isPlacesSheetPresented = false
    isSinglePlaceSheetPresented = true
  }
  
  func showPlacesSheet() {
    isSinglePlaceSheetPresented = false
    isPlacesSheetPresented = true
  }
  
  func closeAllSheets() {
    isSinglePlaceSheetPresented = false
    isPlacesSheetPresented = false
  }
  
  private func centerMapOn(latitude: Double, longitude: Double, delta: Double) {
    cameraPosition = MapCameraPosition.region(
      MKCoordinateRegion(
        center: CLLocationCoordinate2D(
          latitude: latitude - delta * sheetOffsetFactor,
          longitude: longitude,
        ),
        span: MKCoordinateSpan(
          latitudeDelta: delta,
          longitudeDelta: delta
        )
      )
    )
  }
}
