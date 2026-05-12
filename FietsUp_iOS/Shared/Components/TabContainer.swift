//
//  TabContainer.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 11/05/2026.
//

import SwiftUI

struct TabContainer: View {
  @Environment(AppRouter.self) private var router
  
  var body: some View {
    @Bindable var router = router

    TabView(selection: $router.selectedTab) {
      ForEach(AppTab.allCases, id: \.self) { tab in
        Tab(
          tab.title,
          systemImage: tab.icon,
          value: tab
        ) { tab.view }
      }
    }
  }
}
