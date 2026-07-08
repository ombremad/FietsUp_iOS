//
//  AdminSingleReportSheet.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 06/07/2026.
//

import SwiftUI

struct AdminSingleReportSheet: View {
  @Environment(AdminReportsViewModel.self) var vm
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    @Bindable var vm = vm

    Form {
      reportContent
      reportActions(vm: vm)
    }
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .scrollContentBackground(.hidden)
    .navigationTitle("admin.report.title")
    .navigationBarTitleDisplayMode(.inline)
    .presentationDetents([.large])

    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("common.confirm", systemImage: "arrow.up", role: .confirm) {
          Task {
            do {
              try await vm.submit()
              dismiss()
            } catch {
              ErrorService.shared.show(error)
            }
          }
        }.disabled(vm.isLoading)
      }
      ToolbarItem(placement: .cancellationAction) {
        Button("common.cancel", systemImage: "xmark", role: .cancel) { dismiss() }
      }
    }
  }
  
  @ViewBuilder
  private var reportContent: some View {
    if let report = vm.report {
      ReportDetailedCard(report)
    } else {
      ContentUnavailableView("admin.report.contentUnavailable", systemImage: "xmark")
    }
  }
  
  private func reportActions(vm: AdminReportsViewModel) -> some View {
    @Bindable var vm = vm
    return Group {
      AppFormSection("admin.report.actionsSection") {
        VStack(alignment: .leading) {
          Picker("admin.report.action", selection: $vm.reportActionForm.action) {
            ForEach(ModerationAction.allCases, id: \.self) { action in
              Text(action.localizedTitle).tag(action)
            }
          }
          Text(vm.reportActionForm.action.localizedDescription)
            .font(.callout)
            .contentTransition(.interpolate)
            .animation(.snappy, value: vm.reportActionForm.action)
        }
        TextField("admin.report.details", text: $vm.reportActionForm.details, axis: .vertical)
          .lineLimit(2)
      }
      if vm.reportActionForm.action == .edit {
        AppFormSection("admin.report.editSection") {
          if vm.report?.reportedTitle != nil {
            TextField("admin.report.editedTitle", text: $vm.reportActionForm.editedTitle)
              .lineLimit(1)
          }
          TextField("admin.report.editedContent", text: $vm.reportActionForm.editedContent, axis: .vertical)
            .lineLimit(12)
        }
      }
      if vm.reportActionForm.action == .edit || vm.reportActionForm.action == .delete {
        AppFormSection("admin.report.banSection") {
          Toggle("admin.report.withUserBan", isOn: $vm.reportActionForm.banAction)
          if vm.reportActionForm.banAction {
            DatePicker("admin.userBan.endDate", selection: $vm.reportActionForm.banDate, displayedComponents: .date)
          }
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    AdminSingleReportSheet().environment(AdminReportsViewModel())
  }
}
