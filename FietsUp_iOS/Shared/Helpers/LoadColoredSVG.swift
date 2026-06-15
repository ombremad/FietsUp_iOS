//
//  LoadColoredSVG.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 16/06/2026.
//

import Foundation

func loadColoredSVG(
  from url: URL,
  colorHex: String
) async throws -> Data {
  let (data, _) = try await URLSession.shared.data(from: url)
  
  guard var svg = String(data: data, encoding: .utf8) else {
    throw URLError(.cannotDecodeContentData)
  }
  
  let formattedHex = colorHex.hasPrefix("#") ? colorHex : "#\(colorHex)"
  
  svg = svg.replacingOccurrences(of: "#f00", with: formattedHex)
  svg = svg.replacingOccurrences(of: "#ff0000", with: formattedHex)
  svg = svg.replacingOccurrences(of: "#FF0000", with: formattedHex)
  
  guard let modifiedData = svg.data(using: .utf8) else {
    throw URLError(.unknown)
  }
  
  return modifiedData
}
