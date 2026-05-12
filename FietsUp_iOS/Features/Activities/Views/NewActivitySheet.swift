//
//  NewActivitySheet.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 12/05/2026.
//

import SwiftUI

struct NewActivitySheet: View {
  @State private var vm = ActivityViewModel()
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    Form {
      AppFormSection {
        DatePicker(
          "activity.startDate",
          selection: $vm.newActivityForm.startDate,
          in: ...Date.now
        )
        DatePicker(
          "activity.endDate",
          selection: $vm.newActivityForm.endDate,
          in: ...Date.now
        )
      }
      AppFormSection {
        LabeledContent {
          TextField(
            "activity.distance",
            value: $vm.newActivityForm.distance,
            format: .number
          )
          .keyboardType(.numberPad)
          .multilineTextAlignment(.trailing)
        } label: {
          Text("activity.distance")
          Text("activity.inMeters")
            .font(.callout)
            .foregroundStyle(Color.Text.secondary)
        }
      }
    }
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .navigationTitle("activity.newActivity")
    .navigationBarTitleDisplayMode(.inline)
    
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
}

#Preview {
  NavigationStack {
    NewActivitySheet()
  }
}
