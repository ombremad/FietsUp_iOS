//
//  PendingReportsResponse.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 08/07/2026.
//

import Foundation

struct PendingReportsResponse: Decodable {
  let forumPosts: [ForumPostReportResponse]
  let forumComments: [ForumCommentReportResponse]
  let dangerPosts: [DangerPostReportResponse]
  let dangerComments: [DangerCommentReportResponse]
}
