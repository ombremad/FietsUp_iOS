//
//  AdminReportsViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 06/07/2026.
//

import Foundation

@Observable
final class AdminReportsViewModel {
  var isLoading: Bool = false
  var isSingleReportSheetPresented: Bool = false
  
  var reports: [AdminReportResponse] = []
  
  var report: AdminReportResponse? = nil
  var reportActionForm = ReportActionForm()
  struct ReportActionForm {
    var action: ModerationAction = .close
    var banAction: Bool = false
    var details: String = ""
    var editedTitle: String = ""
    var editedContent: String = ""
    var banDate: Date = Defaults.banEndDate
  }
  
  var contentType: ReportContentType? {
    switch report {
      case is ForumPostReportResponse: return .forumPost
      case is ForumCommentReportResponse: return .forumComment
      case is DangerPostReportResponse: return .dangersPost
      case is DangerCommentReportResponse: return .dangersComment
      default: return nil
    }
  }
  
  func load() async {
    isLoading = true
    defer { isLoading = false }
    
    guard reports.isEmpty else { return }
    do {
      try await refreshReports()
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  func open(_ report: AdminReportResponse) {
    reportActionForm = ReportActionForm()
    reportActionForm.editedTitle = report.reportedTitle ?? ""
    reportActionForm.editedContent = report.reportedContent
    self.report = report
    isSingleReportSheetPresented = true
  }
  
  func close() {
    isSingleReportSheetPresented = false
    report = nil
    reportActionForm = ReportActionForm()
  }
  
  func submit() async throws {
    isLoading = true
    defer { isLoading = false }
    
    // TODO: do a single transaction route that handles everything at once from the backend
    
    try ValidationService.reportDetails(reportActionForm.details)
    
    if reportActionForm.action == .edit {
      if contentType == .forumPost || contentType == .dangersPost {
        try ValidationService.title(reportActionForm.editedTitle)
      }
      try ValidationService.content(reportActionForm.editedContent)
      try await performContentEdit()
    }
    if reportActionForm.action == .delete {
      try await performContentDelete()
    }
    if reportActionForm.banAction {
      try ValidationService.banDate(reportActionForm.banDate)
      try await performUserBan()
    }
    
    try await performReportProcessRequest()
    try await refreshReports()
    close()
  }
  
  func refreshReports() async throws {
    let fetched = try await performFetchPendingReports()
    reports = (fetched.forumPosts + fetched.forumComments + fetched.dangerPosts + fetched.dangerComments)
      .sorted { $0.creationDate > $1.creationDate }
  }
    
  private func performFetchPendingReports() async throws -> PendingReportsResponse {
    return try await NetworkService.shared.get(
      endpoint: "/reports/pending",
      requiresAuth: true
    )
  }
  
  private func performReportProcessRequest() async throws {
    guard let id = report?.id, let contentType else { return }

    let body = ReportProcessRequest(from: reportActionForm)
    let _: ReportResponse = try await NetworkService.shared.patch(
      endpoint: "/reports/\(contentType.rawValue)/process/\(id)",
      body: body,
      requiresAuth: true
    )
  }
  
  private func performContentEdit() async throws {
    guard let id = report?.reportedId, let contentType else { return }
    
    let body = PatchContentRequest(title: reportActionForm.editedTitle.isEmpty ? nil : reportActionForm.editedTitle, content: reportActionForm.editedContent)
    let _: PatchContentResponse = try await NetworkService.shared.patch(
      endpoint: "/\(contentType.rawValue)/\(id)",
      body: body,
      requiresAuth: true
    )
  }
  
  private func performContentDelete() async throws {
    guard let id = report?.reportedId, let contentType else { return }
    
    try await NetworkService.shared.delete(
      endpoint: "/\(contentType.rawValue)/\(id)",
      requiresAuth: true
    )
  }
  
  private func performUserBan() async throws {
    guard let id = report?.reportedUserId else { return }
    let body = BanUserRequest(until: reportActionForm.banDate)
    
    let _: UserResponse = try await NetworkService.shared.patch(
      endpoint: "/users/\(id)/ban",
      body: body,
      requiresAuth: true
    )
  }
}
