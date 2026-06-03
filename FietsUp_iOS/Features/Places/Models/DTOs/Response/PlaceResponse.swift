//
//  PlaceResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 03/06/2026.
//

import Foundation

struct PlaceResponse: Decodable, Identifiable {
  let id: UUID
  let name: String
  let categories: [PlaceCategoryResponse]
  let address: String?
  let zipCode: String?
  let city: String?
  let country: String?
  let phoneNumber: String?
  let email: String?
  let website: String?
  let otherDetails: String?
  let latitude: Double
  let longitude: Double
  let creationDate: Date?
  let lastUpdateDate: Date?
}
