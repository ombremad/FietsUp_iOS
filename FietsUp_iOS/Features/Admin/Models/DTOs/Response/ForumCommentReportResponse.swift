//
//  ForumCommentReportResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 06/07/2026.
//

import Foundation

struct ForumCommentReportResponse: AdminReportResponse {
  let id: UUID
  let details: String?
  let creationDate: Date
  let processDate: Date?
  let user: UserPublicResponse
  let category: ModerationCategoryResponse
  let forumComment: ForumCommentShortResponse?
}

// computed properties
extension ForumCommentReportResponse {
  var reportedTitle: String? { nil }
  var reportedContent: String { forumComment?.content ?? "" }
  var reportedUser: String { forumComment?.user.nickname ?? "" }
}
