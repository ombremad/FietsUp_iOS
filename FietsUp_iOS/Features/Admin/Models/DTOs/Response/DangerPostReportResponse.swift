//
//  DangerPostReportResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 08/07/2026.
//

import Foundation

struct DangerPostReportResponse: AdminReportResponse {
  let id: UUID
  let details: String?
  let creationDate: Date
  let processDate: Date?
  let user: UserPublicResponse
  let category: ModerationCategoryResponse
  let dangerPost: DangerPostShortResponse?
}

  // computed properties
extension DangerPostReportResponse {
  var reportedTitle: String? { dangerPost?.title }
  var reportedContent: String { dangerPost?.content ?? "" }
  var reportedUser: String { dangerPost?.user.nickname ?? "" }
}
