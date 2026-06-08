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
  var isLoading: Bool = false
  var isPlacesSheetPresented = false
  var isSinglePlaceSheetPresented = false
  var hasActiveSheet: Bool {
    isSinglePlaceSheetPresented || isPlacesSheetPresented
  }
  
  private let locationService = LocationService.shared
  var hasLocation: Bool { latitude != nil && longitude != nil }
  var latitude: Double? { locationService.latitude }
  var longitude: Double? { locationService.longitude }
  var locationStatus: CLAuthorizationStatus { locationService.authorizationStatus }
  var cameraPosition: MapCameraPosition = .automatic
  private var hasCenteredMap = false
  
  var categories: [PlaceCategoryResponse] = []
  var placesNearby: [PlaceResponse] = []
  var selectedPlace: PlaceResponse? = nil
  
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
    
    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    let sheetOffset = span.latitudeDelta * 0.35
    
    cameraPosition = .region(MKCoordinateRegion(
      center: CLLocationCoordinate2D(
        latitude: place.latitude - sheetOffset,
        longitude: place.longitude
      ),
      span: span
    ))

    showSinglePlaceSheet()
  }
  
  func centerMapOnUser() {
    guard !hasCenteredMap, let lat = latitude, let lon = longitude else { return }
    cameraPosition = .region(MKCoordinateRegion(
      center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
      span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    ))
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
}
