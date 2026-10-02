//
//  PlacesViewModel+NewRating.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 18/09/2026.
//

extension PlacesViewModel {
  func ratePlace(_ note: Int) async throws {
    isLoading = true
    defer { isLoading = false }
    
    try ValidationService.note(note)
    
    if let placeId = selectedPlace?.id {
      let body = PlaceRatingRequest(note: note)
      let response: PlaceResponse = try await NetworkService.shared.post(
        endpoint: "/places/\(placeId)/rating",
        body: body,
        requiresAuth: true
      )
      selectedPlace = response
    }
  }
}
