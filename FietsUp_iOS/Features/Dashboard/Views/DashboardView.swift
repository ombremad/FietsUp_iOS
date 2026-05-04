//
//  DashboardView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 04/05/2026.
//

import SwiftUI

struct DashboardView: View {
  var body: some View {
    VStack {
      Text("Authenticated!")
      Button("Logout") {
        Task {
          try AuthService.shared.logout()
        }
      }
    }
  }
}

#Preview {
  DashboardView()
}
