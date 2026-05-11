//
//  DashboardView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 04/05/2026.
//

import SwiftUI

struct DashboardView: View {
  @Environment(MainViewModel.self) private var mainVM
  @State private var dashboardVM: DashboardViewModel?
  
  var body: some View {
    NavigationStack {
      VStack {
        Text("Authenticated!")
        Button("Logout") {
          Task {
            try AuthService.shared.logout()
          }
        }
      }
    }
    .task {
      if dashboardVM == nil {
        dashboardVM = DashboardViewModel(mainVM: mainVM)
      }
    }
  }
}

#Preview {
  DashboardView()
    .environment(MainViewModel())
}
