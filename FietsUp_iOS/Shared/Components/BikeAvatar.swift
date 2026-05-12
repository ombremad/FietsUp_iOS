//
//  BikeAvatar.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 12/05/2026.
//

import SwiftUI

struct BikeAvatar: View {
  var body: some View {
    ZStack {
      Rectangle()
        .foregroundStyle(.red)
      Text("BIKE placeholder")
        .foregroundStyle(.white)
    }
  }
}

#Preview {
  BikeAvatar()
}
