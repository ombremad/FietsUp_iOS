//
//  AdminPanelView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 06/07/2026.
//

import SwiftUI

struct AdminPanelView: View {
  private let auth = AuthService.shared

  var body: some View {
    List {
      if auth.isAdmin {
        AppFormSection("admin.adminToolsSection.title") {
          NavigationLink(value: AdminDestination.users) {
            SimpleAdminPanelRow(
              titleLocalized: "admin.users.title",
              descriptionLocalized: "admin.users.description",
            )
          }
          NavigationLink(value: AdminDestination.places) {
            SimpleAdminPanelRow(
              titleLocalized: "admin.places.title",
              descriptionLocalized: "admin.places.description",
            )
          }
          NavigationLink(value: AdminDestination.forumCategories) {
            SimpleAdminPanelRow(
              titleLocalized: "admin.forumCategories.title",
              descriptionLocalized: "admin.forumCategories.description",
            )
          }
          NavigationLink(value: AdminDestination.moderationCategories) {
            SimpleAdminPanelRow(
              titleLocalized: "admin.moderationCategories.title",
              descriptionLocalized: "admin.moderationCategories.description",
            )
          }
          NavigationLink(value: AdminDestination.dangerCategories) {
            SimpleAdminPanelRow(
              titleLocalized: "admin.dangerCategories.title",
              descriptionLocalized: "admin.dangerCategories.description",
            )
          }
          NavigationLink(value: AdminDestination.placeCategories) {
            SimpleAdminPanelRow(
              titleLocalized: "admin.placeCategories.title",
              descriptionLocalized: "admin.placeCategories.description",
            )
          }
        }
        if auth.isMod {
          AppFormSection("admin.modToolsSection.title") {
            NavigationLink(value: AdminDestination.reports) {
              SimpleAdminPanelRow(
                titleLocalized: "admin.reports.title",
                descriptionLocalized: "admin.reports.description",
              )
            }
          }
        }
      }
    }
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .scrollContentBackground(.hidden)
    .navigationTitle("admin.panel.title")
    .toolbarTitleDisplayMode(.inline)
    .navigationDestination(for: AdminDestination.self) { destination in
      switch destination {
        case .users: AdminUsersView()
        case .places: AdminPlacesView()
        case .forumCategories: AdminForumCategoriesView()
        case .moderationCategories: AdminModerationCategoriesView()
        case .dangerCategories: AdminDangerCategoriesView()
        case .placeCategories: AdminPlaceCategoriesView()
        case .reports: AdminReportsView()
      }
    }
  }
}

#Preview {
  NavigationStack {
    AdminPanelView()
  }
}
