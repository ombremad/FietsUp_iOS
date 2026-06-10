//
//  Divider.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 10/06/2026.
//

import SwiftUI

struct Divider: View {
  var body: some View {
    Rectangle()
      .foregroundStyle(Color.Surface.divider)
      .frame(height: 1)
  }
}
