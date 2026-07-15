//
//  PlaceCategoriesPickerView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/07/2026.
//

import SwiftUI

struct PlaceCategoriesPickerView: View {
  let allCategories: [PlaceCategoryResponse]
  @Binding var selectedIds: Set<UUID>

  var body: some View {
    List(allCategories, id: \.id, selection: $selectedIds) { category in
      Text(category.name)
    }
    .environment(\.editMode, .constant(.active))
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .scrollContentBackground(.hidden)
    .navigationTitle("admin.places.categories")
    .navigationBarTitleDisplayMode(.inline)
  }
}
