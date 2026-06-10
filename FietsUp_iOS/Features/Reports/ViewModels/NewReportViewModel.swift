//
//  NewReportViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 10/06/2026.
//

import Foundation

@Observable
final class NewReportViewModel {
  var isLoading: Bool = false
  var isSuccessAlertPresented: Bool = false
  
  var newReportForm = NewReportForm()
  struct NewReportForm {
    var details: String = ""
    var hasDetails: Bool = false
    var categoryId: UUID?
  }
  
  var id: UUID?
  var contentType: ReportContentType?
  var availableCategories: [ReportCategoryResponse] = []
    
  func load(id: UUID, contentType: ReportContentType) async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      self.id = id
      self.contentType = contentType
      try await performFetchCategories()
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  func submit() async throws {
    isLoading = true
    defer { isLoading = false }
    
    try ValidationService.categoryId(newReportForm.categoryId)
    if newReportForm.hasDetails {
      try ValidationService.content(newReportForm.details)
    }
    try await performNewReportRequest()
  }
  
  private func performFetchCategories() async throws {
    let response: [ReportCategoryResponse] = try await NetworkService.shared.get(
      endpoint: "/moderation/categories",
      requiresAuth: true
    )
    availableCategories = response
  }
  
  private func performNewReportRequest() async throws {
    guard let id, let contentType else { return }
    
    let body = ReportRequest(from: newReportForm)
    let _: ReportResponse = try await NetworkService.shared.post(
      endpoint: "/reports/\(contentType.rawValue)/\(id)",
      body: body,
      requiresAuth: true
    )
  }
}
