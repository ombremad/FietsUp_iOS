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
  @State private var svgDecoration: Data?
  private let aspectRatio: CGFloat = 121 / 81

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
      if let coloredCycle = svgColoredCycle, let decoration = svgDecoration {
        SVGView(data: coloredCycle)
        SVGView(data: decoration)
      } else {
        ProgressView()
      }
    }
    .aspectRatio(aspectRatio, contentMode: .fit)
    .clipped()
    
    // below: trigger refresh on any type/color/decoration change
    .task(id: "\(cycle.color?.id.uuidString ?? "")-\(cycle.type?.id.uuidString ?? "")-\(cycle.decoration?.id.uuidString ?? "")") {
      await prepareSVGs()
    }
  }
    
  private var placeholderBike: some View {
    Image(systemName: "bicycle")
      .resizable()
      .aspectRatio(contentMode: .fit)
      .foregroundStyle(Color.Text.tertiary)
  }
  
  private func prepareSVGs() async {
    guard let color = cycle.color?.color,
          let cycleUrl = cycle.type?.fileLink, let decorationUrl = cycle.decoration?.fileLink
    else { return }
    
    do {
      svgColoredCycle = try await loadColoredSVG(from: cycleUrl, colorHex: color)
      svgDecoration = try await loadSVG(from: decorationUrl)
    } catch {
      print(error)
    }
  }
}

#Preview {
  BikeAvatar(Cycle(from: UserResponse.placeholder))
}
