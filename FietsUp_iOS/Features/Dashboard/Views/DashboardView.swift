//
//  DashboardView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 04/05/2026.
//

import SwiftUI

struct DashboardView: View {
  @State private var vm = DashboardViewModel()
  private let auth = AuthService.shared

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: 24) {
          if let user = auth.currentUser {
            UserCardBig(user: user)
          } else {
            ProgressView()
          }
        }.padding()
      }
      .foregroundStyle(Color.Text.primary)
      .background { Color.Surface.background.ignoresSafeArea() }
      .navigationTitle("dashboard.hello")
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          NavigationLink {
            SettingsView()
          } label: {
            Label("settings", systemImage: "gear")
          }
        }
      }
    }
    .task {
      await auth.restoreSession()
    }
  }
}

#Preview {
  DashboardView()
}
