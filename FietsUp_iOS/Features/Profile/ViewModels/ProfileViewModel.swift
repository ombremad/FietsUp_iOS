//
//  ProfileViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 30/06/2026.
//

import Foundation

@Observable
final class ProfileViewModel {
  private let auth = AuthService.shared
  var isLoading: Bool = false

  var cycleTypes: [CycleTypeResponse] = []
  var cycleColors: [CycleColorResponse] = []
  var cycleDecorations: [CycleDecorationResponse] = []
  
  var profileForm = ProfileForm()
  struct ProfileForm {
    var nickname: String = ""
    var bio: String = ""
    var cycleType: CycleType? = nil
    var cycleColor: CycleColor? = nil
    var cycleDecoration: CycleDecoration? = nil
  }
  
  func load() async {
    isLoading = true
    defer { isLoading = false }
    
    if let user = auth.currentUser {
      profileForm.nickname = user.nickname
      profileForm.cycleType = user.cycle.type
      profileForm.cycleColor = user.cycle.color
      profileForm.cycleDecoration = user.cycle.decoration
      if let bio = user.bio { profileForm.bio = bio }
    }
    await performFetchCycleData()
  }
  
  func submit() async throws {
    isLoading = true
    defer { isLoading = false }
    
    try ValidationService.nickname(profileForm.nickname)
    try ValidationService.bio(profileForm.bio)
    
    if let user = auth.currentUser {
        try await performUpdateUser(user)
        await auth.forceRefresh()
    }
  }
  
  private func performFetchCycleData() async {
    do {
      if cycleTypes.isEmpty {
        try await performFetchCycleTypes()
      }
      if cycleColors.isEmpty {
        try await performFetchCycleColors()
      }
      if cycleDecorations.isEmpty {
        try await performFetchCycleDecorations()
      }
    } catch {
      ErrorService.shared.show(error)
    }
  }

  private func performFetchCycleTypes() async throws {
    let response: [CycleTypeResponse] = try await NetworkService.shared.get(
      endpoint: "/cycles/types",
      requiresAuth: true
    )
    cycleTypes = response
  }
  
  private func performFetchCycleColors() async throws {
    let response: [CycleColorResponse] = try await NetworkService.shared.get(
      endpoint: "/cycles/colors",
      requiresAuth: true
    )
    cycleColors = response
  }
  
  private func performFetchCycleDecorations() async throws {
    let response: [CycleDecorationResponse] = try await NetworkService.shared.get(
      endpoint: "/cycles/decorations",
      requiresAuth: true
    )
    cycleDecorations = response
  }
  
  private func performUpdateUser(_ user: User) async throws {
    let body = UserProfileUpdateRequest(from: profileForm, compareTo: user)
    let _: UserResponse = try await NetworkService.shared.patch(
      endpoint: "/users/me",
      body: body,
      requiresAuth: true
    )
  }
}
