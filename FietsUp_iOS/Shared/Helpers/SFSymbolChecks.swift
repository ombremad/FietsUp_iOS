//
//  SFSymbolCatalog.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 10/07/2026.
//

import Foundation

struct SFSymbolsFile: Decodable {
  let symbols: [String: String]
  
  enum CodingKeys: String, CodingKey { case symbols }
}

final class SFSymbolCatalog {
  static let shared = SFSymbolCatalog()

  let symbols: Set<String>

  private init() {
    guard
      let url = Bundle.main.url(forResource: "sf_symbols", withExtension: "json"),
      let data = try? Data(contentsOf: url),
      let file = try? JSONDecoder().decode(SFSymbolsFile.self, from: data)
    else {
      fatalError("Unable to load sf_symbols.json")
    }

    symbols = Set(file.symbols.keys)
  }

  func contains(_ symbol: String) -> Bool {
    symbols.contains(symbol)
  }
}
