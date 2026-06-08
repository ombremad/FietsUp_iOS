//
//  NewDangerPostViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 08/06/2026.
//

import Foundation
import CoreLocation

@Observable
final class NewDangerPostViewModel {
  var isLoading: Bool = false
  
  private let locationService = LocationService.shared
  var hasLocation: Bool { latitude != nil && longitude != nil }
  var latitude: Double? { locationService.latitude }
  var longitude: Double? { locationService.longitude }
  var locationStatus: CLAuthorizationStatus { locationService.authorizationStatus }
  var approximateLocationName: String? { locationService.locationName }
  
  var newDangerPostForm = NewDangerPostForm()
  struct NewDangerPostForm {
    var title: String = ""
    var content: String = ""
    var categoryId: UUID?
  }
  
  var availableCategories: [DangerCategoryResponse] = []
  
  func load() async {
    isLoading = true
    defer { isLoading = false }
    
    locationService.requestLocation()
    
    if availableCategories.isEmpty {
      do {
        try await performFetchCategories()
      } catch {
        ErrorService.shared.show(error)
      }
    }
  }
  
  func submit() async throws {
    isLoading = true
    defer { isLoading = false }
    
    try ValidationService.title(newDangerPostForm.title)
    try ValidationService.content(newDangerPostForm.content)
    try ValidationService.categoryId(newDangerPostForm.categoryId)
    try ValidationService.location(latitude: latitude, longitude: longitude)
    try await performNewDangerPostRequest()
  }
  
  private func performFetchCategories() async throws {
    let response: [DangerCategoryResponse] = try await NetworkService.shared.get(
      endpoint: "/dangers/categories",
      requiresAuth: true
    )
    availableCategories = response
  }
  
  private func performNewDangerPostRequest() async throws {
    if let categoryId = newDangerPostForm.categoryId {
      do {
        let body = DangerPostRequest(from: newDangerPostForm, latitude: latitude!, longitude: longitude!)
        let _: DangerPostResponse = try await NetworkService.shared.post(
          endpoint: "/dangers/posts/category/\(categoryId)",
          body: body,
          requiresAuth: true
        )
      } catch {
        ErrorService.shared.show(error)
      }
    }
  }
}
