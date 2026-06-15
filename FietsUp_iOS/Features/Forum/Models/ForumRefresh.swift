//
//  ForumEvent.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/06/2026.
//

import Foundation

enum ForumRefresh {
  static let refreshPostView = Notification.Name("forum.refreshPostView")
  static let refreshCategoryView = Notification.Name("forum.refreshCategoryView")
  static let refreshForumView = Notification.Name("forum.refreshForumView")
}
