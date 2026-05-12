//
//  AppRouter.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 12/05/2026.
//

import SwiftUI

@Observable
final class AppRouter {
  static let shared = AppRouter()
  private init() {}
  
  var selectedTab: AppTab = .dashboard
  private var paths: [AppTab: NavigationPath] = [:]
  
  func path(for tab: AppTab) -> Binding<NavigationPath> {
    Binding(
      get: { self.paths[tab] ?? NavigationPath() },
      set: { self.paths[tab] = $0 }
    )
  }
  
  func push<V: Hashable>(_ value: V, on tab: AppTab? = nil) {
    let target = tab ?? selectedTab
    var path = paths[target] ?? NavigationPath()
    path.append(value)
    paths[target] = path
  }
  
  func popToRoot(_ tab: AppTab? = nil) {
    paths[tab ?? selectedTab] = NavigationPath()
  }
  
  func navigate(to tab: AppTab) {
    selectedTab = tab
  }
  
  func navigate<V: Hashable>(to tab: AppTab, push value: V) {
    selectedTab = tab
    push(value, on: tab)
  }
  
  func reset() async {
    try? await Task.sleep(for: .seconds(1)) // prevent change during visual transition
    selectedTab = .dashboard
    paths.removeAll()
  }
}
