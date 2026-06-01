//
//  MetersToKilometers.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 01/06/2026.
//

import Foundation

func metersToFormattedKilometers(_ meters: Int) -> String {
  (Double(meters) / 1000).formatted(.number.precision(.fractionLength(0...2)))
}
