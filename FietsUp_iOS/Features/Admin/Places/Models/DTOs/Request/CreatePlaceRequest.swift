//
//  CreatePlaceRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/07/2026.
//

import Foundation

struct CreatePlaceRequest: Encodable {
  let name: String
  let categoriesIds: [UUID]
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
  
  init(from form: AdminPlacesViewModel.PlaceForm) {
    self.name = form.name
    self.categoriesIds = form.categories.map(\.id)
    self.address = form.address.isEmpty ? nil : form.address
    self.zipCode = form.zipCode.isEmpty ? nil : form.zipCode
    self.city = form.city.isEmpty ? nil : form.city
    self.country = form.country.isEmpty ? nil : form.country
    self.phoneNumber = form.phoneNumber.isEmpty ? nil : form.phoneNumber
    self.email = form.email.isEmpty ? nil : form.email
    self.website = form.website.isEmpty ? nil : form.website
    self.otherDetails = form.otherDetails.isEmpty ? nil : form.otherDetails
    self.latitude = form.latitude
    self.longitude = form.longitude
  }
}
