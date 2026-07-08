//
//  ForumDestination.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 02/06/2026.
//

import Foundation

enum ForumDestination: Hashable {
  case category(id: UUID)
  case post(id: UUID)
}
