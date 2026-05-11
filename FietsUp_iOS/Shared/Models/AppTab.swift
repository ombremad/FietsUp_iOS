//
//  AppTab.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 11/05/2026.
//

import SwiftUI

enum AppTab: Int, Hashable, CaseIterable {
  case dashboard, dangers, places, forum
  
  var title: String {
    switch self {
      case .dashboard: "tab.dashboard"
      case .dangers: "tab.dangers"
      case .places: "tab.places"
      case .forum: "tab.forum"
    }
  }
  
  var icon: String {
    switch self {
      case .dashboard: "arrow.trianglehead.topright.capsulepath.clockwise"
      case .dangers: "exclamationmark.square"
      case .places: "mappin.and.ellipse"
      case .forum: "bubble.left.and.text.bubble.right"
    }
  }
  
  @ViewBuilder
  var view: some View {
    Group {
      switch self {
        case .dashboard: DashboardView()
        case .dangers:   DangersView()
        case .places:    PlacesView()
        case .forum:     ForumView()
      }
    }
    .errorOverlay()
  }
}
