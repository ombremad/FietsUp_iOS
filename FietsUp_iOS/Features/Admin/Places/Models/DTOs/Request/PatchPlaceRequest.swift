//
//  PatchPlaceRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/07/2026.
//

import Foundation

struct PatchPlaceRequest: Encodable {
  let name: String?
  let categoriesIds: [UUID]?
  let address: String?
  let zipCode: String?
  let city: String?
  let country: String?
  let phoneNumber: String?
  let email: String?
  let website: String?
  let otherDetails: String?
  let latitude: Double?
  let longitude: Double?
  
  init(from form: AdminPlacesViewModel.PlaceForm, compareTo old: PlaceResponse) {
    self.name = form.name != old.name ? form.name : nil
    self.categoriesIds = form.categories.map(\.id) != old.categories.map(\.id) ? form.categories.map(\.id) : nil
    self.address = form.address != (old.address ?? "") ? form.address : nil
    self.zipCode = form.zipCode != (old.zipCode ?? "") ? form.zipCode : nil
    self.city = form.city != (old.city ?? "") ? form.city : nil
    self.country = form.country != (old.country ?? "") ? form.country : nil
    self.phoneNumber = form.phoneNumber != (old.phoneNumber ?? "") ? form.phoneNumber : nil
    self.email = form.email != (old.email ?? "") ? form.email : nil
    self.website = form.website != (old.website ?? "") ? form.website : nil
    self.otherDetails = form.otherDetails != (old.otherDetails ?? "") ? form.otherDetails : nil
    self.latitude = form.latitude != old.latitude ? form.latitude : old.latitude
    self.longitude = form.longitude != old.longitude ? form.longitude : old.longitude
  }
}
