//
//  SVGHelpers.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 16/06/2026.
//

import Foundation

func loadSVG(from url: URL) async throws -> Data {
  let (data, _) = try await URLSession.shared.data(from: url)
  return data
}

func loadColoredSVG(
  from url: URL,
  colorHex: String
) async throws -> Data {
  let occurrencesToReplace: [String] = ["#f00", "#F00", "#ff0000", "#FF0000"]
  let data = try await loadSVG(from: url)
  
  guard var svg = String(data: data, encoding: .utf8) else {
    throw URLError(.cannotDecodeContentData)
  }
  
  let formattedHex = colorHex.hasPrefix("#") ? colorHex : "#\(colorHex)"
  
  for occ in occurrencesToReplace {
    svg = svg.replacingOccurrences(of: occ, with: formattedHex)
  }
  
  guard let modifiedData = svg.data(using: .utf8) else {
    throw URLError(.unknown)
  }
  
  return modifiedData
}
