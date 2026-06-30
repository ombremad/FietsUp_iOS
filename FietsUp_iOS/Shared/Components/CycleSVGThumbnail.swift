//
//  CycleSVGThumbnail.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 30/06/2026.
//

import SwiftUI
import SVGView

struct CycleSVGThumbnail: View {
  let urlString: String
  @State private var svgData: Data?
  
  private let aspectRatio: CGFloat = 121 / 81

  var body: some View {
    Group {
      if let svgData {
        SVGView(data: svgData)
          .aspectRatio(aspectRatio, contentMode: .fit)
          .clipped()
      } else {
        ProgressView()
      }
    }
    .task(id: urlString) {
      guard let url = URL(string: urlString) else { return }
      do {
        let (data, _) = try await URLSession.shared.data(from: url)
        svgData = data
      } catch {
        print(error)
      }
    }
  }
}
