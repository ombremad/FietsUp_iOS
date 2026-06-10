//
//  ReverseGeocoder.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 10/06/2026.
//

import CoreLocation
import MapKit

enum ReverseGeocoder {
    static func resolve(latitude: Double, longitude: Double) async throws -> String? {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        guard let request = MKReverseGeocodingRequest(location: location) else { return nil }
        let mapItems = try await request.mapItems
        return mapItems.first?.address?.shortAddress
    }
}
