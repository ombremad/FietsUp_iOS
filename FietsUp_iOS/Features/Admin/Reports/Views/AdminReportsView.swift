//
//  AdminReportsView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 06/07/2026.
//

import SwiftUI

struct AdminReportsView: View {
  @State private var vm = AdminReportsViewModel()
  
  var body: some View {
    List {
      AppFormSection {
        if vm.isLoading {
          ForEach(0..<3, id: \.self) { _ in
            ReportRowCard.placeholder
          }
          .redacted(reason: .placeholder)
          .shimmering()
        } else {
          if vm.reports.isEmpty {
            ContentUnavailableView("admin.noPendingReports.title", systemImage: "checkmark.circle")
          } else {
            ForEach(vm.reports, id: \.id) { report in
              ReportRowCard(report)
                .onTapGesture { vm.open(report) }
            }
          }
        }
      }
    }
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .scrollContentBackground(.hidden)
    .navigationTitle("admin.forumPanel.pendingReports")
    .toolbarTitleDisplayMode(.inline)

    .appSheet(isPresented: $vm.isSingleReportSheetPresented) {
      NavigationStack {
        AdminSingleReportSheet().environment(vm)
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
  AdminReportsView()
}
