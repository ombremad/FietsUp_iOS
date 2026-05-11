//
//  TabContainer.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 11/05/2026.
//

import SwiftUI

struct TabContainer: View {
  @Environment(MainViewModel.self) private var mainVM

  var body: some View {
    @Bindable var mainVM = mainVM

    TabView(selection: $mainVM.selectedTab) {
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
