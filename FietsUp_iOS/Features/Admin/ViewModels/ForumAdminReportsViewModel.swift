//
//  ForumAdminReportsViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 06/07/2026.
//

import Foundation

@Observable
final class ForumAdminReportsViewModel {
  var isLoading: Bool = false
  var isSingleReportSheetPresented: Bool = false
  
  var forumReports: [ForumReportResponse] = []
  
  var report: ForumReportResponse? = nil
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
    
    guard forumReports.isEmpty else { return }
    do {
      try await refreshReports()
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  func open(_ report: ForumReportResponse) {
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
    let postReports: [ForumPostReportResponse] = try await performFetchForumPostReports()
    let commentReports: [ForumCommentReportResponse] = try await performFetchForumCommentReports()
    forumReports = (postReports + commentReports).sorted { $0.creationDate > $1.creationDate }
  }
  
  private func performFetchForumPostReports() async throws -> [ForumPostReportResponse] {
    let response: [ForumPostReportResponse] = try await NetworkService.shared.get(
      endpoint: "/reports/forum/posts/pending",
      requiresAuth: true
    )
    return response
  }
  
  private func performFetchForumCommentReports() async throws -> [ForumCommentReportResponse] {
    let response: [ForumCommentReportResponse] = try await NetworkService.shared.get(
      endpoint: "/reports/forum/comments/pending",
      requiresAuth: true
    )
    return response
  }
  
  private func performReportProcessRequest() async throws {
    var contentType: ReportContentType?
    if report is ForumPostReportResponse { contentType = .forumPost }
    if report is ForumCommentReportResponse { contentType = .forumComment }

    guard let id = report?.id, let contentType else { return }

    let body = ReportProcessRequest(from: reportActionForm)
    let _: ReportResponse = try await NetworkService.shared.patch(
      endpoint: "/reports/\(contentType.rawValue)/process/\(id)",
      body: body,
      requiresAuth: true
    )
  }
}
