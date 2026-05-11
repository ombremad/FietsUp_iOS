//
//  DashboardViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 11/05/2026.
//

import Foundation

@Observable
final class DashboardViewModel {
  private let mainVM: MainViewModel
  init(mainVM: MainViewModel) {
    self.mainVM = mainVM
  }
}
