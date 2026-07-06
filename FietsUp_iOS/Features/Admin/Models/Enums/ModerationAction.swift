//
//  ModerationAction.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 06/07/2026.
//

import SwiftUI

enum ModerationAction: CaseIterable {
  case close, edit, delete
  
  var localizedTitle: LocalizedStringKey {
    switch self {
      case .close: "moderation.action.close.title"
      case .edit: "moderation.action.edit.title"
      case .delete: "moderation.action.delete.title"
    }
  }
  
  var localizedDescription: LocalizedStringKey {
    switch self {
      case .close: "moderation.action.close.description"
      case .edit: "moderation.action.edit.description"
      case .delete: "moderation.action.delete.description"
    }
  }
}
