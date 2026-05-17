//
//  Untitled.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/05/2026.
//

import Foundation

protocol ForumCardItem {
  var title: String { get }
  var content: String { get }
  var lastActivityDate: Date? { get }
  var totalReplies: Int { get }
  var author: UserShortResponse? { get }
}

extension ForumCategoryResponse: ForumCardItem {
  var title: String { name }
  var content: String { details }
  var totalReplies: Int { totalPosts }
  var author: UserShortResponse? { nil }
}

extension ForumPostShortResponse: ForumCardItem {
  var totalReplies: Int { totalComments }
  var author: UserShortResponse? { user }
}
