//
//  DistanceBetweenTwoGeoPoints.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 03/06/2026.
//

import CoreLocation

func distanceBetweenTwoPoints(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Int {
  let point1 = CLLocation(latitude: lat1, longitude: lon1)
  let point2 = CLLocation(latitude: lat2, longitude: lon2)
  
  return Int(point1.distance(from: point2).rounded())
}
