//
//  NewDangerPostSheet.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 08/06/2026.
//

import SwiftUI

struct NewDangerPostSheet: View {
  @State private var vm = NewDangerPostViewModel()
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    Form {
      AppFormSection {
        VStack(alignment: .leading) {
          Text("dangers.postWillBeGeolocated")
            .font(.caption2).bold()
          Text("dangers.around \(vm.approximateLocationName ?? "location.unknownLocation")")
        }
        .listRowBackground(Color.clear)
      }
      
      AppFormSection {
        Picker("danger.category", selection: $vm.newDangerPostForm.categoryId) {
          Text("danger.selectCategory")
          ForEach(vm.availableCategories) { category in
            Label(category.name, systemImage: category.iconName).tag(category.id)
          }
        }
        TextField("danger.title", text: $vm.newDangerPostForm.title)
        TextField("danger.content", text: $vm.newDangerPostForm.content, axis: .vertical)
          .lineLimit(12)
      }
    }
    .listSectionSpacing(4)
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .navigationTitle("post.newPost")
    .navigationBarTitleDisplayMode(.inline)

    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("common.confirm", systemImage: "arrow.up", role: .confirm) {
          Task {
            try await vm.submit()
            dismiss()
          }
        }.disabled(vm.isLoading)
      }
      ToolbarItem(placement: .cancellationAction) {
        Button("common.cancel", systemImage: "xmark", role: .cancel) { dismiss() }
      }
    }
    
    .task {
      await vm.load()
    }
  }
}

#Preview {
  NavigationStack {
    NewDangerPostSheet()
  }
}
