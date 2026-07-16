//
//  TitleLabel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 11/05/2026.
//

import SwiftUI

struct TitleLabel: View {
  var body: some View {
    HStack {
      Spacer()
      Text("FietsUp")
        .font(.title)
        .foregroundStyle(Color.Surface.Login.primary)
        .padding(.horizontal, Defaults.padding.large)
        .padding(.vertical, Defaults.padding.xsmall)
        .background(Color.Surface.field)
        .cornerRadius(Defaults.radius.large)
      Spacer()
    }
    .listRowBackground(Color.clear)    
  }
}
