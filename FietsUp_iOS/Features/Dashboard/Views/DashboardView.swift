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
  private let router = AppRouter.shared

  var body: some View {
    ScrollView {
      VStack(spacing: 42) {
        if let user = auth.currentUser {
          UserCardBig(user: user)
        } else {
          ProgressView()
        }
        
        VStack(alignment: .leading, spacing: 24) {
          Text("dashboard.myActivities")
            .font(.title3)
            .foregroundStyle(Color.Text.tertiary)
          
          HStack(spacing: 24) {
            DashboardButton(
              label: "dashboard.activities.preview",
              iconName: "chart.bar.xaxis.ascending.badge.clock",
              role: .neutral
            ) {}
            DashboardButton(
              label: "dashboard.activities.add",
              iconName: "plus.circle",
              role: .primary
            ) { vm.isNewActivitySheetPresented.toggle() }
          }
        }
        
      }
      .padding()
      .frame(maxWidth: .infinity)
    }
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .navigationTitle("dashboard.hello")
    .navigationDestination(for: DashboardDestination.self) { destination in
      switch destination {
        case .settings: SettingsView()
      }
    }
    
    .sheet(isPresented: $vm.isNewActivitySheetPresented) {
      NavigationStack { NewActivitySheet().errorOverlay() }
        .presentationDetents([.medium])
    }
      
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button {
          router.push(DashboardDestination.settings)
        } label: {
          Label("settings", systemImage: "gear")
        }
      }
    }
    
    .task {
      await auth.restoreSession()
    }
  }
}

#Preview {
  NavigationStack {
    DashboardView()
  }
}
