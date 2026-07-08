//
//  DangerCommentReportResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 08/07/2026.
//

import Foundation

struct DangerCommentReportResponse: AdminReportResponse {
  let id: UUID
  let details: String?
  let creationDate: Date
  let processDate: Date?
  let user: UserPublicResponse
  let category: ModerationCategoryResponse
  let dangerComment: DangerCommentShortResponse?
}

  // computed properties
extension DangerCommentReportResponse {
  var reportedTitle: String? { nil }
  var reportedContent: String { dangerComment?.content ?? "" }
  var reportedUser: String { dangerComment?.user.nickname ?? "" }
}
