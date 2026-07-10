//
//  ReportRowCard.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 06/07/2026.
//

import SwiftUI

struct ReportRowCard: View {
  let report: AdminReportResponse
  init(_ report: AdminReportResponse) {
    self.report = report
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack {
        Text(report.category.name)
          .foregroundStyle(Color.Text.tertiary)
        Spacer()
        Text(report.creationDate.formatted(date: .abbreviated, time: .omitted))
          .foregroundStyle(Color.Text.secondary)
      }
      .font(.caption)
      .lineLimit(1)
      if let reportedTitle = report.reportedTitle {
        Text(reportedTitle)
          .font(.body).bold()
          .lineLimit(1)
      }
      Text(report.reportedContent)
        .font(.body)
        .lineLimit(2)
    }
    .contentShape(Rectangle())
  }
}

#Preview {
  NavigationStack {
    Form {
      ReportRowCard(ForumCommentReportResponse.placeholder)
      ReportRowCard(ForumPostReportResponse.placeholder)
    }
  }
}
