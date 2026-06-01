//
//  TabContainer.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 11/05/2026.
//

import SwiftUI

struct TabContainer: View {
  var body: some View {
    @Bindable var router = AppRouter.shared
    
    TabView(selection: $router.selectedTab) {
      ForEach(AppTab.allCases, id: \.self) { tab in
        Tab(tab.title, systemImage: tab.icon, value: tab) {
          NavigationStack(path: router.path(for: tab)) {
            tab.view
          }
        }
      }
    }
  }
}
