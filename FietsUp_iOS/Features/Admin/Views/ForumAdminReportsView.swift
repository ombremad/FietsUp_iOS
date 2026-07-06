//
//  ForumAdminReportsView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 06/07/2026.
//

import SwiftUI

struct ForumAdminReportsView: View {
  @State private var vm = ForumAdminReportsViewModel()
  
  var body: some View {
    Form {
      AppFormSection {
        if vm.isLoading {
          ForEach(0..<3, id: \.self) { _ in
            ReportRowCard.placeholder
          }
          .redacted(reason: .placeholder)
          .shimmering()
        } else {
          if vm.forumReports.isEmpty {
            ContentUnavailableView("admin.noPendingReports.title", systemImage: "checkmark.circle")
          } else {
            ForEach(vm.forumReports, id: \.id) { report in
              ReportRowCard(report)
                .onTapGesture {
                  vm.open(report)
                }
            }
          }
        }
      }
    }
    .background { Color.Surface.background.ignoresSafeArea() }
    .navigationTitle("admin.forumPanel.openReports")
    .toolbarTitleDisplayMode(.inline)

    .appSheet(isPresented: $vm.isSingleReportSheetPresented) {
      NavigationStack {
        ForumAdminSingleReportSheet().environment(vm)
      }
    }
    .task {
      await vm.load()
    }
    .refreshable {
      Task { try await vm.refreshReports() }
    }
  }
}

#Preview {
  ForumAdminReportsView()
}
