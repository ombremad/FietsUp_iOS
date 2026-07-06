//
//  ReportDetailedCard.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 06/07/2026.
//

import SwiftUI

struct ReportDetailedCard: View {
  let report: ForumReportResponse
  init(_ report: ForumReportResponse) {
    self.report = report
  }
  
  var body: some View {
    AppFormSection("admin.report.reportMetaSection") {
      LabeledContent("admin.report.category", value: report.category.name)
      LabeledContent("admin.report.reportedBy", value: report.user.nickname)
      LabeledContent("admin.report.reportedOn", value: report.creationDate.formatted(date: .abbreviated, time: .shortened))
    }
    AppFormSection("admin.report.reportedContentSection") {
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
