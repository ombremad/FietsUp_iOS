//
//  LocationService.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 03/06/2026.
//

import Foundation
import CoreLocation

@Observable
final class LocationService: NSObject, CLLocationManagerDelegate {
  static let shared = LocationService()
  
  var latitude: Double?
  var longitude: Double?
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
    latitude = locations.last?.coordinate.latitude
    longitude = locations.last?.coordinate.longitude
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    ErrorService.shared.show(error)
  }
}
