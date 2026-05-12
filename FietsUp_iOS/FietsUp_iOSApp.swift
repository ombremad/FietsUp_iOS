//
//  FietsUp_iOSApp.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 04/05/2026.
//

import SwiftUI

@main
struct FietsUp_iOSApp: App {
  @State private var authService = AuthService.shared
  @State private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
          ZStack {
            if authService.isAuthenticated {
              TabContainer()
                .environment(router)
                .transition(.opacity)
            } else {
              LoginView()
                .transition(.opacity)
            }
          }
          .animation(.default, value: authService.isAuthenticated)
          .font(.body)
        }
    }
}
