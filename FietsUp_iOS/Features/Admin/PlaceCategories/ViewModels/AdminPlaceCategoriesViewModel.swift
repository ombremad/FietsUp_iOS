//
//  AdminPlaceCategoriesViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 10/07/2026.
//

import Foundation
import SwiftUI

@Observable
final class AdminPlaceCategoriesViewModel {
  var isLoading: Bool = false
  var isSingleCategorySheetPresented: Bool = false
  
  var categories: [PlaceCategoryResponse] = []
  
  var category: PlaceCategoryResponse? = nil
  var categoryForm = CategoryForm()
  struct CategoryForm {
    var name: String = ""
    var iconName: String = ""
  }
  
  func load() async {
    isLoading = true
    defer { isLoading = false }
    
    guard categories.isEmpty else { return }
    do {
      try await refreshCategories()
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  func refreshCategories() async throws {
    let response = try await performFetchCategories()
    categories = response
    category = nil
    categoryForm = .init()
  }
  
  func create() {
    category = nil
    categoryForm = .init()
    isSingleCategorySheetPresented = true
  }
  
  func edit(_ category: PlaceCategoryResponse) {
    self.category = category
    categoryForm = .init(name: category.name, iconName: category.iconName)
    isSingleCategorySheetPresented = true
  }
  
  func submit() async throws {
    isLoading = true
    defer { isLoading = false }
    
    categoryForm.iconName = categoryForm.iconName.lowercased()
    try ValidationService.name(categoryForm.name)
    try ValidationService.iconName(categoryForm.iconName)
    
    if category != nil {
      try await performPatchCategory()
    } else {
      try await performCreateCategory()
    }
    
    try await refreshCategories()
  }
  
  func delete(at offsets: IndexSet) async {
    let toDelete = offsets.map { categories[$0] }
    do {
      for category in toDelete {
        try await performDeleteCategory(id: category.id)
      }
      categories.remove(atOffsets: offsets)
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  private func performCreateCategory() async throws {
    let body = CreatePlaceCategoryRequest(from: categoryForm)
    
    let _: PlaceCategoryResponse = try await NetworkService.shared.post(
      endpoint: "/places/categories/",
      body: body,
      requiresAuth: true
    )
  }
  
  private func performPatchCategory() async throws {
    guard let oldCategory = category else { return }
    let body = PatchPlaceCategoryRequest(from: categoryForm, compareTo: oldCategory)
    
    let _: PlaceCategoryResponse = try await NetworkService.shared.patch(
      endpoint: "/places/categories/\(oldCategory.id)",
      body: body,
      requiresAuth: true
    )
  }
  
  private func performDeleteCategory(id: UUID) async throws {
    return try await NetworkService.shared.delete(
      endpoint: "/places/categories/\(id)",
      requiresAuth: true
    )
  }
  
  private func performFetchCategories() async throws -> [PlaceCategoryResponse] {
    return try await NetworkService.shared.get(
      endpoint: "/places/categories",
      requiresAuth: true
    )
  }

}
