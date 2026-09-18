//
//  PlaceRatingRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 18/09/2026.
//

struct PlaceRatingRequest: Encodable {
  let note: Int
  
  init(note: Int) {
    self.note = note
  }
}
