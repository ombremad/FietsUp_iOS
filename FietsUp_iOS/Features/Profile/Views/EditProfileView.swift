//
//  EditProfileView.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 30/06/2026.
//

import SwiftUI

struct EditProfileView: View {
  @State private var vm = ProfileViewModel()
  private let auth = AuthService.shared
  
  @State private var selectedTab: Tab = .type
  enum Tab: String, CaseIterable {
    case type = "cycle.type"
    case color = "cycle.color"
    case decoration = "cycle.decoration"
  }
  
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    Form {
      AppFormSection {
        Group {
          TextField("form.nickname", text: $vm.profileForm.nickname)
            .textContentType(.nickname)
            .autocorrectionDisabled()
            .submitLabel(.done)
          
          TextField("form.bio", text: $vm.profileForm.bio, axis: .vertical)
            .lineLimit(3)
            .frame(height: 50)
            .submitLabel(.done)
        }
      }
      
      AppFormSection {
        VStack {
          BikeAvatar(Cycle(
            color: vm.profileForm.cycleColor,
            type: vm.profileForm.cycleType,
            decoration: vm.profileForm.cycleDecoration
          ))
          .frame(height: 200)
          
          Picker("", selection: $selectedTab) {
            ForEach(Tab.allCases, id: \.self) { tab in
              Text(tab.rawValue).tag(tab)
            }
          }
          .pickerStyle(.segmented)

          TabView(selection: $selectedTab) {
            Text("Type")
              .tag(Tab.type)
            Text("Color")
              .tag(Tab.color)
            Text("Decoration")
              .tag(Tab.decoration)
          }
          .tabViewStyle(.page(indexDisplayMode: .never))
          .frame(height: 200)

        }
        .listRowBackground(Color.clear)

      }
    }
    .foregroundStyle(Color.Text.secondary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .navigationTitle("editProfile.title")
    .toolbarTitleDisplayMode(.inline)
    .scrollContentBackground(.hidden)
    .scrollDismissesKeyboard(.interactively)
    .task {
      await vm.load()
    }
    
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("common.confirm", systemImage: "checkmark", role: .confirm) {
          Task {
            await vm.submit()
            dismiss()
          }
        }.disabled(vm.isLoading)
      }
    }
  }
}

#Preview {
  EditProfileView()
}
