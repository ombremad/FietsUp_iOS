//
//  FormattedElapsedTime.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/05/2026.
//

import Foundation

func formattedElapsedTime(_ date: Date) -> String {
  let formatter = DateComponentsFormatter()
  formatter.unitsStyle = .full
  formatter.maximumUnitCount = 1
  formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute, .second]
  
  let now = Date.now
  let start = min(date, now)
  let end = max(date, now)
  return formatter.string(from: start, to: end) ?? ""
}
