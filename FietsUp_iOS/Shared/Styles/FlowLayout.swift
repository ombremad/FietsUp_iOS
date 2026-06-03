//
//  FlowLayout.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 03/06/2026.
//

import SwiftUI

struct FlowLayout: Layout {
  var spacing: CGFloat = 8

  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
    let rows = computeRows(proposal: proposal, subviews: subviews)
    let height = rows.map(\.height).reduce(0, +) + CGFloat(max(rows.count - 1, 0)) * spacing
    return CGSize(width: proposal.replacingUnspecifiedDimensions().width, height: height)
  }

  func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
    var y = bounds.minY
    for row in computeRows(proposal: ProposedViewSize(bounds.size), subviews: subviews) {
      let rowWidth = row.subviews.reduce(0) { $0 + $1.sizeThatFits(.unspecified).width }
      + CGFloat(row.subviews.count - 1) * spacing
      var x = bounds.minX + (bounds.width - rowWidth) / 2  // ← centered start
      for subview in row.subviews {
        let size = subview.sizeThatFits(.unspecified)
        subview.place(at: CGPoint(x: x, y: y), proposal: .unspecified)
        x += size.width + spacing
      }
      y += row.height + spacing
    }
  }
  
  private struct Row {
    var subviews: [LayoutSubview]
    var height: CGFloat
  }

  private func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [Row] {
    let maxWidth = proposal.replacingUnspecifiedDimensions().width
    var rows: [Row] = []
    var currentSubviews: [LayoutSubview] = []
    var currentWidth: CGFloat = 0
    var currentHeight: CGFloat = 0

    for subview in subviews {
        let size = subview.sizeThatFits(.unspecified)
        if currentWidth + size.width > maxWidth, !currentSubviews.isEmpty {
            rows.append(Row(subviews: currentSubviews, height: currentHeight))
            currentSubviews = [subview]
            currentWidth = size.width + spacing
            currentHeight = size.height
        } else {
            currentSubviews.append(subview)
            currentWidth += size.width + spacing
            currentHeight = max(currentHeight, size.height)
        }
    }
    if !currentSubviews.isEmpty {
        rows.append(Row(subviews: currentSubviews, height: currentHeight))
    }
    return rows
  }
}
