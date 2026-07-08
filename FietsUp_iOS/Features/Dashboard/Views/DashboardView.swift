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
          UserCardBig(user)
            .onTapGesture {
              router.push(DashboardDestination.editProfile)
            }
        } else {
          UserCardBig(.placeholder)
            .redacted(reason: .placeholder)
            .shimmering()
        }
        
        VStack(alignment: .leading, spacing: 24) {
          Text("dashboard.myActivities")
            .font(.title3)
            .foregroundStyle(Color.Text.tertiary)
          
          HStack(spacing: 24) {
            DashboardButton(
              label: String(localized: "dashboard.activities.overview"),
              iconName: "chart.bar.xaxis.ascending.badge.clock",
              role: .neutral
            ) { router.push(DashboardDestination.activities) }
            DashboardButton(
              label: String(localized: "dashboard.activities.add"),
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
        case .activities: ActivitiesView()
        case .editProfile: EditProfileView()
        case .adminPanel: AdminPanelView()
      }
    }
    
    .appSheet(isPresented: $vm.isNewActivitySheetPresented) {
      NavigationStack { NewActivitySheet() }
        .presentationDetents([.medium])
    }
    .appSheet(isPresented: $vm.isStreakSheetPresented) {
      StreakUpdateSheet(streak: auth.currentUser?.streak ?? 0, lastKnownStreak: vm.lastKnownStreakForSheet)
    }
      
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button {
          router.push(DashboardDestination.settings)
        } label: {
          Label("settings", systemImage: "gear")
        }
      }
      if auth.isAdmin || auth.isMod {
        ToolbarItem(placement: .primaryAction) {
          Button {
            router.push(DashboardDestination.adminPanel)
          } label: {
            Label("adminPanel", systemImage: "key.shield")
          }
        }
      }
    }
    
    .task {
      await vm.load()
    }
    .onChange(of: auth.currentUser?.streak) { oldValue, newValue in
      guard let _ = oldValue, let _ = newValue else { return }
      vm.isStreakSheetPresented.toggle()
    }
  }
}

#Preview {
  NavigationStack {
    DashboardView()
  }
}
