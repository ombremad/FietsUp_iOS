//
//  BikeAvatar.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 12/05/2026.
//

import SwiftUI
import SVGView

struct BikeAvatar: View {
  @State private var svgColoredCycle: Data?

  let cycle: Cycle
  init(_ cycle: Cycle) {
    self.cycle = cycle
  }
  
  var body: some View {
    if cycle.color != nil, cycle.type != nil, cycle.decoration != nil {
      customBike
    } else {
      placeholderBike
    }
  }
  
  @ViewBuilder
  private var customBike: some View {
    ZStack {
      if let coloredCycle = svgColoredCycle, let decoration = cycle.decoration?.fileLink {
        SVGView(data: coloredCycle)
        SVGView(contentsOf: decoration)
      } else {
        ProgressView()
      }
    }
    .task { await prepareSVG() }
  }
    
  private var placeholderBike: some View {
    Image(systemName: "bicycle")
      .resizable()
      .aspectRatio(contentMode: .fit)
      .foregroundStyle(Color.Text.tertiary)
  }
  
  private func prepareSVG() async {
    guard let color = cycle.color?.color,
      let cycleUrl = cycle.type?.fileLink
    else { return }
    
    do {
      svgColoredCycle = try await loadColoredSVG(from: cycleUrl, colorHex: color)
    } catch {
      print(error)
    }
  }
}

#Preview {
  BikeAvatar(Cycle(from: UserResponse.placeholder))
}
