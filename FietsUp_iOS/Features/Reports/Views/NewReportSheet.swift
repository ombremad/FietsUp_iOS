//
//  NewReportSheet.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 10/06/2026.
//

import SwiftUI

struct NewReportSheet: View {
  @State private var vm = NewReportViewModel()
  @Environment(\.dismiss) private var dismiss
  
  let id: UUID
  let contentType: ReportContentType
  let content: String
  
  var body: some View {
    Form {
      AppFormSection {
        VStack(alignment: .leading) {
          Text("report.youWillReportTheFollowingContent")
            .font(.caption2).bold()
          Text(content)
        }
        .listRowBackground(Color.clear)
      }
      
      AppFormSection {
        Picker("report.category", selection: $vm.newReportForm.categoryId) {
          Text("report.selectCategory").tag(UUID?.none)
          ForEach(vm.availableCategories) { category in
            Text(category.name).tag(category.id)
          }
        }
      }
      
      AppFormSection {
        Toggle("report.addContent", isOn: $vm.newReportForm.hasDetails)
        if vm.newReportForm.hasDetails {
          TextField("report.content", text: $vm.newReportForm.details, axis: .vertical)
            .lineLimit(12)
        }
      }
    }
    .listSectionSpacing(16)
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .navigationTitle("report.newReport")
    .navigationBarTitleDisplayMode(.inline)
    .presentationDetents([.medium, .large])
    
    .alert("report.success.title", isPresented: $vm.isSuccessAlertPresented) {
      Button("common.ok") { dismiss() }
    } message: {
      Text("report.success.message")
    }

    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("common.confirm", systemImage: "arrow.up", role: .confirm) {
          Task {
            do {
              try await vm.submit()
              vm.isSuccessAlertPresented.toggle()
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
    
    .task {
      await vm.load(id: id, contentType: contentType)
    }
  }
}
