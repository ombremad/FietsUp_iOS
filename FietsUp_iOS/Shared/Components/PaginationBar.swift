//
//  PaginationBar.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 17/07/2026.
//

import SwiftUI

struct PaginationBar: View {
  let metadata: PageMetadata
  let onPrevious: () -> Void
  let onNext: () -> Void
    
  var body: some View {
    let isFirstPage = metadata.page <= 1
    let isLastPage = metadata.page >= metadata.pageCount
    
    if metadata.pageCount == 0 { EmptyView() } else {
      HStack {
        Button("page.previous", systemImage: "chevron.left", action: onPrevious)
          .disabled(isFirstPage)
          .opacity(isFirstPage ? 0.25 : 1)
        
        Spacer()
        
        Text("\(metadata.page) / \(metadata.pageCount)")
          .font(.caption)
          .foregroundStyle(Color.Text.secondary)
        
        Spacer()
        
        Button("page.next", systemImage: "chevron.right", action: onNext)
          .disabled(isLastPage)
          .opacity(isLastPage ? 0.25 : 1)
        
      }
      .font(.callout)
      .foregroundStyle(Color.Text.primary)
      .buttonStyle(.glass)
      .labelStyle(.iconOnly)
      .padding()
      .background {
        RoundedRectangle(cornerRadius: Defaults.radius.large)
          .fill(.clear)
          .glassEffect()
      }
      .contentShape(RoundedRectangle(cornerRadius: Defaults.radius.large))
      .onTapGesture {}
      .padding()
    }
  }
}
