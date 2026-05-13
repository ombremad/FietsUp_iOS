//
//  ActivityRow.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 13/05/2026.
//

import SwiftUI

struct ActivityRow: View {
  let activity: ActivityResponse
  
  init(_ activity: ActivityResponse) {
    self.activity = activity
  }
  
  var body: some View {
    HStack {
      HStack(spacing: 4) {
        Text((Double(activity.distance) / 1000).formatted(.number.precision(.fractionLength(0...2))))
          .bold()
        Text("common.unit.km")
      }

      Spacer()
      
      Text(activity.startDate.formatted(date: .numeric, time: .omitted))
        .font(.callout)
        .foregroundStyle(Color.Text.secondary)
    }
    .font(.body)
    .foregroundStyle(Color.Text.primary)
  }
}

#Preview {
  List {
    ActivityRow(
      ActivityResponse (
        id: UUID(),
        startDate: Date(timeIntervalSinceNow: 12000),
        endDate: Date.now,
        length: 12000,
        distance: 14829
      )
    )
  }
}
