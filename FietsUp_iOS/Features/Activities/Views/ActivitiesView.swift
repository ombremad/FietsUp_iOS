//
//  ActivityView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 13/05/2026.
//

import SwiftUI

struct ActivitiesView: View {
  @State private var vm = ActivitiesViewModel()
  
  var body: some View {
    Group {
      if vm.isLoading {
        ProgressView()
      } else if vm.activities.isEmpty {
        ContentUnavailableView(
          "activities.empty.title",
          systemImage: "figure.outdoor.cycle",
          description: Text("activities.empty.description")
        )
      } else {
        List {
          ForEach(vm.activities) { activity in
            ActivityRow(activity)
          }
          .onDelete { offsets in
            Task { await vm.delete(at: offsets) }
          }
        }
      }
    }
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .scrollContentBackground(.hidden)
    .navigationTitle("activities.title")
    .navigationBarTitleDisplayMode(.inline)

    .task {
      await vm.load()
    }
  }
}

#Preview {
  NavigationStack {
    ActivitiesView()
  }
}
