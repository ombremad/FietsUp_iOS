//
//  NewDangerPostSheet.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 08/06/2026.
//

import SwiftUI

struct NewDangerPostSheet: View {
  @Environment(DangersViewModel.self) private var vm
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    @Bindable var vm = vm

    Form {
      AppFormSection {
        VStack(alignment: .leading) {
          Text("dangers.postWillBeGeolocated")
            .font(.caption2).bold()
          Text("common.map.around \(vm.newPostForm.approximateLocation ?? "location.unknownLocation")")
        }
        .listRowBackground(Color.clear)
      }
      
      AppFormSection {
        Picker("danger.category", selection: $vm.newPostForm.categoryId) {
          Text("danger.selectCategory").tag(UUID?.none)
          ForEach(vm.availableCategories) { category in
            Label(category.name, systemImage: category.iconName)
              .tag(category.id)
          }
        }
      }
      
      AppFormSection {
        TextField("danger.title", text: $vm.newPostForm.title)
        TextField("danger.content", text: $vm.newPostForm.content, axis: .vertical)
          .lineLimit(12)
      }
    }
    .listSectionSpacing(16)
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .navigationTitle("post.newPost")
    .navigationBarTitleDisplayMode(.inline)
    .presentationDetents([.medium, .large])

    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("common.confirm", systemImage: "arrow.up", role: .confirm) {
          Task { await vm.submitPost() }
        }.disabled(vm.isLoading)
      }
      ToolbarItem(placement: .cancellationAction) {
        Button("common.cancel", systemImage: "xmark", role: .cancel) { dismiss() }
      }
    }
    
    .task {
      await vm.getNewPostApproximateLocation()
    }
  }
}

#Preview {
  NavigationStack {
    NewDangerPostSheet()
  }
}
