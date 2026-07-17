//
//  AdminPlacesViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/07/2026.
//

import Foundation
import SwiftUI

@Observable
final class AdminPlacesViewModel {
  var isLoading: Bool = false
  var isSinglePlaceSheetPresented: Bool = false
  var metadata: PageMetadata = Defaults.pagination.metadata
  
  var places: [PlaceResponse] = []
  var categories: [PlaceCategoryResponse] = []
  
  var place: PlaceResponse? = nil
  var placeForm = PlaceForm()
  struct PlaceForm {
    var name: String = ""
    var categories: [PlaceCategoryResponse] = []
    var address: String = ""
    var zipCode: String = ""
    var city: String = ""
    var country: String = ""
    var phoneNumber: String = ""
    var email: String = ""
    var website: String = ""
    var otherDetails: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var useCurrentLocation: Bool = false
  }
  
  private let locationService = LocationService.shared
  var hasLocation: Bool { latitude != nil && longitude != nil }
  var latitude: Double? { locationService.latitude }
  var longitude: Double? { locationService.longitude }
  
  func load() async {
    isLoading = true
    defer { isLoading = false }
    
    locationService.requestLocation()
    
    if categories.isEmpty {
      do {
        try await refreshCategories()
      } catch {
        ErrorService.shared.show(error)
      }
    }
    
    if places.isEmpty {
      do {
        try await refreshPlaces()
      } catch {
        ErrorService.shared.show(error)
      }
    }
  }
  
  func goToPage(_ page: Int) async {
    guard !isLoading, page <= metadata.pageCount, page > 0, page != metadata.page else { return }
    
    isLoading = true
    defer { isLoading = false }
    
    let previousPage = metadata.page
    metadata.page = page
    
    do {
      try await refreshPlaces()
    } catch {
      metadata.page = previousPage
      ErrorService.shared.show(error)
    }
  }
  
  func goToNextPage() async {
    await goToPage(metadata.page + 1)
  }
  
  func goToPreviousPage() async {
    await goToPage(metadata.page - 1)
  }
  
  func refreshCategories() async throws {
    let response = try await performFetchCategories()
    categories = response
  }
  
  func refreshPlaces() async throws {
    let response = try await performFetchPlaces()
    places = response.items
    metadata = response.metadata
    place = nil
    placeForm = .init()
  }
  
  func create() {
    place = nil
    placeForm = .init()
    isSinglePlaceSheetPresented = true
  }
  
  func edit(_ place: PlaceResponse) {
    self.place = place
    placeForm = .init(
      name: place.name,
      categories: place.categories,
      address: place.address ?? "",
      zipCode: place.zipCode ?? "",
      city: place.city ?? "",
      country: place.country ?? "",
      phoneNumber: place.phoneNumber ?? "",
      email: place.email ?? "",
      website: place.website ?? "",
      otherDetails: place.otherDetails ?? "",
      latitude: place.latitude,
      longitude: place.longitude,
    )
    isSinglePlaceSheetPresented = true
  }
  
  func submit() async throws {
    isLoading = true
    defer { isLoading = false }
    
    if placeForm.useCurrentLocation {
      try ValidationService.location(latitude: latitude, longitude: longitude)
      placeForm.latitude = latitude!
      placeForm.longitude = longitude!
    }
    
    try ValidationService.name(placeForm.name)
    try ValidationService.placeCategories(placeForm.categories)
    if !placeForm.address.isEmpty {
      try ValidationService.address(placeForm.address)
    }
    if !placeForm.zipCode.isEmpty {
      try ValidationService.zipCode(placeForm.zipCode)
    }
    if !placeForm.city.isEmpty {
      try ValidationService.city(placeForm.city)
    }
    if !placeForm.country.isEmpty {
      try ValidationService.country(placeForm.country)
    }
    if !placeForm.phoneNumber.isEmpty {
      try ValidationService.phoneNumber(placeForm.phoneNumber)
    }
    if !placeForm.email.isEmpty {
      try ValidationService.email(placeForm.email)
    }
    if !placeForm.website.isEmpty {
      try ValidationService.website(placeForm.website)
    }
    if !placeForm.otherDetails.isEmpty {
      try ValidationService.otherDetails(placeForm.otherDetails)
    }
    try ValidationService.location(latitude: placeForm.latitude, longitude: placeForm.longitude)
    
    if place != nil {
      try await performPatchPlace()
    } else {
      try await performCreatePlace()
    }
    
    try await refreshPlaces()
  }
  
  func delete(at offsets: IndexSet) async {
    let toDelete = offsets.map { places[$0] }
    do {
      for place in toDelete {
        try await performDeletePlace(id: place.id)
      }
      try await refreshPlaces()
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func performCreatePlace() async throws {
    let body = CreatePlaceRequest(from: placeForm)
    
    let _: PlaceResponse = try await NetworkService.shared.post(
      endpoint: "/places/",
      body: body,
      requiresAuth: true
    )
  }
  
  private func performPatchPlace() async throws {
    guard let oldPlace = place else { return }
    let body = PatchPlaceRequest(from: placeForm, compareTo: oldPlace)
    
    let _: PlaceResponse = try await NetworkService.shared.patch(
      endpoint: "/places/\(oldPlace.id)",
      body: body,
      requiresAuth: true
    )
  }
  
  private func performDeletePlace(id: UUID) async throws {
    return try await NetworkService.shared.delete(
      endpoint: "/places/\(id)",
      requiresAuth: true
    )
  }
  
  private func performFetchPlaces() async throws -> Page<PlaceResponse> {
    return try await NetworkService.shared.get(
      endpoint: "/places?page=\(metadata.page)&per=\(metadata.per)",
      requiresAuth: true
    )
  }
  
  private func performFetchCategories() async throws -> [PlaceCategoryResponse] {
    return try await NetworkService.shared.get(
      endpoint: "/places/categories",
      requiresAuth: true
    )
  }
}
