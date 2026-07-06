//
//  ForumReportResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 06/07/2026.
//

import Foundation

protocol ForumReportResponse: Decodable {
  var id: UUID { get }
  var details: String? { get }
  var creationDate: Date { get }
  var processDate: Date? { get }
  var user: UserPublicResponse { get }
  var category: ModerationCategoryResponse { get }
  var reportedTitle: String? { get }
  var reportedContent: String { get }
  var reportedUser: String { get }
}
