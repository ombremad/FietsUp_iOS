//
//  LocationService.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 03/06/2026.
//

import Foundation
import CoreLocation
import MapKit

@Observable
final class LocationService: NSObject, CLLocationManagerDelegate {
  static let shared = LocationService()
  
  var latitude: Double?
  var longitude: Double?
  var locationName: String?

  var authorizationStatus: CLAuthorizationStatus = .notDetermined
  
  private let locationManager = CLLocationManager()
  
  private override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
  }
  
  func requestLocation() {
    locationManager.requestWhenInUseAuthorization()
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    authorizationStatus = manager.authorizationStatus
    if manager.authorizationStatus == .authorizedWhenInUse {
      manager.requestLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    latitude = location.coordinate.latitude
    longitude = location.coordinate.longitude
    reverseGeocode(location)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    ErrorService.shared.show(error)
  }
  
  private func reverseGeocode(_ location: CLLocation) {
    Task {
      do {
        guard let request = MKReverseGeocodingRequest(location: location) else { return }
        let mapItems = try await request.mapItems
        guard let mapItem = mapItems.first else { return }
        locationName = mapItem.address?.shortAddress
      } catch {
        print("Reverse geocoding failed: \(error.localizedDescription)")
      }
    }
  }
}
