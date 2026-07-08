//
//  ReportDetailedCard.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 06/07/2026.
//

import SwiftUI

struct ReportDetailedCard: View {
  let report: AdminReportResponse
  init(_ report: AdminReportResponse) {
    self.report = report
  }
  
  var body: some View {
    AppFormSection("admin.report.reportMetaSection") {
      LabeledContent("admin.report.category", value: report.category.name)
      LabeledContent("admin.report.reportedBy", value: report.user.nickname)
      LabeledContent("admin.report.reportedOn", value: report.creationDate.formatted(date: .abbreviated, time: .shortened))
    }
    AppFormSection("admin.report.reportedContentSection") {
      var contentType: String {
        let key: String.LocalizationValue
        switch report {
          case is ForumPostReportResponse: key = "admin.report.contentType.forumPost"
          case is ForumCommentReportResponse: key = "admin.report.contentType.forumComment"
          case is DangerPostReportResponse: key = "admin.report.contentType.dangerPost"
          case is DangerCommentReportResponse: key = "admin.report.contentType.dangerComment"
          default: key = "admin.report.contentType.unknown"
        }
        return String(localized: key)
      }
      LabeledContent("admin.report.contentType", value: contentType)
      LabeledContent("admin.report.author", value: report.reportedUser)
      if let title = report.reportedTitle {
        LabeledContent("admin.report.reportedTitle", value: title)
      }
      LabeledContent("admin.report.reportedContent", value: report.reportedContent)
    }
  }
}

#Preview("Post") {
  NavigationStack {
    Form {
      ReportDetailedCard(ForumPostReportResponse.placeholder)
    }
  }
}

#Preview("Comment") {
  NavigationStack {
    Form {
      ReportDetailedCard(ForumCommentReportResponse.placeholder)
    }
  }
}
