//
//  MainViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 11/05/2026.
//

import SwiftUI

@Observable
final class MainViewModel {
  var path = NavigationPath()
  var selectedTab: AppTab = .dashboard
}
