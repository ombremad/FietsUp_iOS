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
        .padding(.horizontal, 28)
        .padding(.vertical, 8)
        .background(Color.Surface.field)
        .cornerRadius(20)
      Spacer()
    }
    .listRowBackground(Color.clear)    
  }
}
