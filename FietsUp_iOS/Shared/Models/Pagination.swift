//
//  Pagination.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 17/07/2026.
//

struct PageMetadata: Decodable {
  var page: Int
  var per: Int
  var total: Int
  var pageCount: Int {
    per > 0 ? (total + per - 1) / per : 1
  }
}

struct Page<T: Decodable>: Decodable {
  let items: [T]
  let metadata: PageMetadata
}
