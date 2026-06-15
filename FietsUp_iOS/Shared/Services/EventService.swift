//
//  EventService.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/06/2026.
//

import SwiftUI

@Observable
final class EventService {
  static func post(_ event: Notification.Name) {
    NotificationCenter.default.post(name: event, object: nil)
  }
  
  static func stream(for event: Notification.Name) -> NotificationCenter.Notifications {
    NotificationCenter.default.notifications(named: event)
  }
}
