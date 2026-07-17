//
//  AdminUsersView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/07/2026.
//

import SwiftUI

struct AdminUsersView: View {
  @State private var vm = AdminUsersViewModel()
  
  var body: some View {
    List {
      if vm.isLoading {
        AppFormSection {
          ForEach(0..<3, id: \.self) { _ in
            SimpleAdminPanelRow(
              title: Placeholder.User.email,
              description: Placeholder.User.nickname
            )
          }
        }
        .redacted(reason: .placeholder)
        .shimmering()
      } else {
        ForEach(vm.users) { user in
          SimpleAdminPanelRow(
            title: user.email,
            description: user.nickname
          ).onTapGesture { vm.edit(user) }
        }
      }
    }
    
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .scrollContentBackground(.hidden)
    .navigationTitle("admin.users.title")
    .toolbarTitleDisplayMode(.inline)
    
    .appSheet(isPresented: $vm.isSingleUserSheetPresented) {
      NavigationStack { AdminUserSheet().environment(vm) }
    }
    
    .safeAreaInset(edge: .bottom) {
      PaginationBar(
        metadata: vm.metadata,
        onPrevious: { Task { await vm.goToPreviousPage() } },
        onNext: { Task { await vm.goToNextPage() } },
      )
    }
        
    .task { await vm.load() }
    .refreshable {
      Task { try await vm.refreshUsers() }
    }
  }
}
