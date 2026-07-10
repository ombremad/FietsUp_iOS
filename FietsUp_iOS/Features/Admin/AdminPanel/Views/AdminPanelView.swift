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
    Form {
      if auth.isAdmin {
        AppFormSection("admin.adminToolsSection.title") {
          NavigationLink { AdminForumCategoriesView()
          } label: {
            SimpleAdminPanelRow(
              titleLocalized: "admin.forumCategories.title",
              descriptionLocalized: "admin.forumCategories.description",
            )
          }
          NavigationLink { AdminPlaceCategoriesView()
          } label: {
            SimpleAdminPanelRow(
              titleLocalized: "admin.placeCategories.title",
              descriptionLocalized: "admin.placeCategories.description",
            )
          }
        }
        if auth.isMod {
          AppFormSection("admin.modToolsSection.title") {
            NavigationLink { AdminReportsView()
            } label: {
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
  }
}

#Preview {
  NavigationStack {
    AdminPanelView()
  }
}
