//
//  AdminUsersViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/07/2026.
//

import SwiftUI

@Observable
final class AdminUsersViewModel {
  var isLoading: Bool = true
  var isSingleUserSheetPresented: Bool = false
  var metadata: PageMetadata = Defaults.pagination.metadata
  
  var users: [UserResponse] = []

  var user: UserResponse? = nil
  var userForm = UserForm()
  struct UserForm {
    var email: String = ""
    var nickname: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var bio: String = ""
    var rights = UserRights.user
    var isBanned: Bool = false
    var banEndDate: Date? = nil
  }
  
  func load() async {
    isLoading = true
    defer { isLoading = false }
    
    guard users.isEmpty else { return }
    do {
      try await refreshUsers()
    } catch {
      ErrorService.shared.show(error)
    }
  }
  
  func goToPage(_ page: Int) async {
    guard !isLoading, page <= metadata.pageCount, page > 0, page != metadata.page else { return }
    
    isLoading = true
    defer { isLoading = false }
    
    let previousPage = metadata.page
    metadata.page = page
    
    do {
      try await refreshUsers()
    } catch {
      metadata.page = previousPage
      ErrorService.shared.show(error)
    }
  }
  
  func goToNextPage() async {
    await goToPage(metadata.page + 1)
  }
  
  func goToPreviousPage() async {
    await goToPage(metadata.page - 1)
  }
  
  func refreshUsers() async throws {
    let response = try await performFetchUsers()
    metadata = response.metadata
    users = response.items    
    user = nil
    userForm = .init()
  }
  
  func edit(_ user: UserResponse) {
    self.user = user
    userForm = .init(
      email: user.email,
      nickname: user.nickname,
      firstName: user.firstName,
      lastName: user.lastName,
      bio: user.bio ?? "",
      rights: UserRights(rawValue: user.adminRights) ?? .user,
      isBanned: user.banEndDate != nil,
      banEndDate: user.banEndDate
    )
    isSingleUserSheetPresented = true
  }
  
  func submit() async throws {
    isLoading = true
    defer { isLoading = false }
    
    guard let oldUser = self.user else { return }
    
    try ValidationService.email(userForm.email)
    try ValidationService.nickname(userForm.nickname)
    try ValidationService.firstName(userForm.firstName)
    try ValidationService.lastName(userForm.lastName)
    try ValidationService.bio(userForm.bio)
    
    if userForm.isBanned && userForm.banEndDate != oldUser.banEndDate, let banEndDate = userForm.banEndDate {
      try ValidationService.banDate(banEndDate)
      try await performUserBan()
    }
    if oldUser.banEndDate != nil && !userForm.isBanned {
      try await performDeleteUserBan()
    }

    try await performPatchUser()
    try await refreshUsers()
  }
  
  private func performUserBan() async throws {
    guard let id = user?.id, let banEndDate = userForm.banEndDate else { return }
    let body = BanUserRequest(until: banEndDate)
    
    let _: UserResponse = try await NetworkService.shared.patch(
      endpoint: "/users/\(id)/ban",
      body: body,
      requiresAuth: true
    )
  }

  private func performDeleteUserBan() async throws {
    guard let id = user?.id else { return }
    try await NetworkService.shared.delete(
      endpoint: "/users/\(id)/ban",
      requiresAuth: true
    )
  }
    
  private func performPatchUser() async throws {
    guard let oldUser = self.user else { return }
    
    let body = PatchUserAdminRequest(from: userForm, compareTo: oldUser)
    let _: UserResponse = try await NetworkService.shared.patch(
      endpoint: "/users/\(oldUser.id)",
      body: body,
      requiresAuth: true
    )
  }
  
  private func performFetchUsers() async throws -> Page<UserResponse> {
    return try await NetworkService.shared.get(
      endpoint: "/users?page=\(metadata.page)&per=\(metadata.per)",
      requiresAuth: true
    )
  }
  
  func setBanDefaults(_ isBanned: Bool) {
    userForm.isBanned = isBanned
    if isBanned && userForm.banEndDate == nil {
      userForm.banEndDate = Defaults.values.banEndDate
    }
  }
}
