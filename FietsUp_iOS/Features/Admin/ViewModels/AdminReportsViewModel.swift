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
    var editedContent: String = ""
    var banDate: Date = .now.addingTimeInterval(60 * 60 * 24 * 7) // default ban duration: one week
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
    
    try ValidationService.reportDetails(reportActionForm.details)
    
    // TODO: finish this
    if reportActionForm.action == .edit {
      try ValidationService.content(reportActionForm.editedContent)
      // try await performPostEdit()
    }
    if reportActionForm.action == .delete {
      // try await performPostDelete()
    }
    if reportActionForm.banAction {
      try ValidationService.banDate(reportActionForm.banDate)
      // try await performUserBan()
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
    let response: PendingReportsResponse = try await NetworkService.shared.get(
      endpoint: "/reports/pending",
      requiresAuth: true
    )
    return response
  }
  
  private func performReportProcessRequest() async throws {
    var contentType: ReportContentType?
    if report is ForumPostReportResponse { contentType = .forumPost }
    if report is ForumCommentReportResponse { contentType = .forumComment }
    if report is DangerPostReportResponse { contentType = .dangersPost }
    if report is DangerCommentReportResponse { contentType = .dangersComment }

    guard let id = report?.id, let contentType else { return }

    let body = ReportProcessRequest(from: reportActionForm)
    let _: ReportResponse = try await NetworkService.shared.patch(
      endpoint: "/reports/\(contentType.rawValue)/process/\(id)",
      body: body,
      requiresAuth: true
    )
  }
}
