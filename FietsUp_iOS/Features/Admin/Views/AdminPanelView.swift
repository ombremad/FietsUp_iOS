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
      AppFormSection {
        if auth.isAdmin {
          adminNavRowView(
            title: "admin.forumCategories.title",
            description: "admin.forumCategories.description",
            destination: AdminForumCategoriesView(),
          )
        }
        if auth.isMod {
          adminNavRowView(
            title: "admin.reports.title",
            description: "admin.reports.description",
            destination: AdminReportsView(),
          )
        }
      }
    }
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .scrollContentBackground(.hidden)
    .navigationTitle("admin.panel.title")
    .toolbarTitleDisplayMode(.inline)
  }
  
  @ViewBuilder
  private func adminNavRowView<Destination: View>(title: LocalizedStringKey, description: LocalizedStringKey, destination: Destination) -> some View {
    NavigationLink(destination: destination, label: {
      VStack(alignment: .leading) {
        Text(title)
          .font(.body).bold()
        Text(description)
          .font(.caption2)
      }
    })
  }
}

#Preview {
  NavigationStack {
    AdminPanelView()
  }
}
