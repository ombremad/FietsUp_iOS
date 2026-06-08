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
  private var hasCenteredMap = false
  
  // fixed values for maps settings
  private let zoomedDelta = 0.01
  private let dezoomedDelta = 0.02
  private let sheetOffsetFactor: Double = 0.35

  // places related values
  var categories: [PlaceCategoryResponse] = []
  var placesNearby: [PlaceResponse] = []
  var selectedPlace: PlaceResponse? = nil
  
  // functions
  
  func load() async {
    locationService.requestLocation()
    if categories.isEmpty { await performFetchCategories() }
    centerMapOnUser()
    
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
    cameraPosition = offsetCameraPosition(
      latitude: place.latitude,
      longitude: place.longitude,
      span: MKCoordinateSpan(latitudeDelta: zoomedDelta, longitudeDelta: zoomedDelta)
    )
    showSinglePlaceSheet()
  }
  
  func centerMapOnUser() {
    guard !hasCenteredMap, let lat = latitude, let lon = longitude else { return }
    cameraPosition = offsetCameraPosition(
      latitude: lat,
      longitude: lon,
      span: MKCoordinateSpan(latitudeDelta: dezoomedDelta, longitudeDelta: dezoomedDelta)
    )
    hasCenteredMap = true
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
    
  private func offsetCameraPosition(
    latitude: Double,
    longitude: Double,
    span: MKCoordinateSpan
  ) -> MapCameraPosition {
    .region(MKCoordinateRegion(
      center: CLLocationCoordinate2D(
        latitude: latitude - span.latitudeDelta * sheetOffsetFactor,
        longitude: longitude
      ),
      span: span
    ))
  }
}
