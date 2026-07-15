//
//  ForumPostReportResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 06/07/2026.
//

import Foundation

struct ForumPostReportResponse: AdminReportResponse {
  let id: UUID
  let details: String?
  let creationDate: Date
  let processDate: Date?
  let user: UserPublicResponse
  let category: ModerationCategoryResponse
  let forumPost: ForumPostShortResponse?
}

// computed properties
extension ForumPostReportResponse {
  var reportedId: UUID? { forumPost?.id }
  var reportedTitle: String? { forumPost?.title }
  var reportedContent: String { forumPost?.content ?? "" }
  var reportedUser: String { forumPost?.user.nickname ?? "" }
  var reportedUserId: UUID? { forumPost?.user.id }
}
