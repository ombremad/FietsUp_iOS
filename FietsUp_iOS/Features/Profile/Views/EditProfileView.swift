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
  
  @Environment(\.dismiss) private var dismiss
  
  @State private var selectedTab: Tab = .type
  enum Tab: String, CaseIterable {
    case type = "cycle.type"
    case color = "cycle.color"
    case decoration = "cycle.decoration"
  }
    
  var body: some View {
    VStack {
      profileInfo
      cycleSelector
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
            do {
              try await vm.submit()
              dismiss()
            } catch {
              ErrorService.shared.show(error)
            }
          }
        }.disabled(vm.isLoading)
      }
    }
  }
  
  private var profileInfo: some View {
    Form {
      AppFormSection {
        Group {
          TextField("form.nickname", text: $vm.profileForm.nickname)
            .textContentType(.nickname)
            .autocorrectionDisabled()
            .submitLabel(.done)
          
          TextField("form.bio", text: $vm.profileForm.bio, axis: .vertical)
            .lineLimit(3)
            .frame(height: 60)
            .submitLabel(.done)
        }
      }
    }
    .scrollDisabled(true)
    .frame(height: 200)
  }
  
  private var cycleSelector: some View {
    VStack(spacing: Defaults.spacing.vertical.large) {
      BikeAvatar(Cycle(
        color: vm.profileForm.cycleColor,
        type: vm.profileForm.cycleType,
        decoration: vm.profileForm.cycleDecoration
      ))
      
      VStack(spacing: 0) {
        Picker("cycle.selector.title", selection: $selectedTab) {
          ForEach(Tab.allCases, id: \.self) { tab in
            Text(LocalizedStringKey(tab.rawValue)).tag(tab)
          }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        
        TabView(selection: $selectedTab) {
          typeSelector.tag(Tab.type)
          colorSelector.tag(Tab.color)
          decorationSelector.tag(Tab.decoration)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
      }
      .frame(height: 200)
    }
  }
  
  private var typeSelector: some View {
    ScrollView(.horizontal) {
      LazyHStack(spacing: Defaults.spacing.horizontal.large) {
        ForEach(vm.cycleTypes, id: \.id) { cycleType in
          ZStack {
            Rectangle().stroke(
              vm.profileForm.cycleType?.id == cycleType.id
              ? Color.accentColor
              : Color.clear,
              lineWidth: 4
            )
            CycleSVGThumbnail(urlString: cycleType.fileLink)
          }
          .frame(width: Defaults.bikeAvatar.customization.width, height: Defaults.bikeAvatar.customization.height)
          .contentShape(Rectangle())
          .onTapGesture {
            vm.profileForm.cycleType = CycleType(from: cycleType)
          }
        }
      }
    }
    .safeAreaPadding(.horizontal)
    .scrollIndicators(.hidden)
  }
  
  private var colorSelector: some View {
    ScrollView(.horizontal) {
      LazyHStack(spacing: Defaults.spacing.horizontal.large) {
        ForEach(vm.cycleColors, id: \.id) { cycleColor in
          ZStack {
            Circle()
              .foregroundStyle(Color(hex: cycleColor.color))
            Circle().stroke(
              vm.profileForm.cycleColor?.id == cycleColor.id
              ? Color.accentColor
              : Color.clear,
              lineWidth: 4
            )
          }
          .frame(height: 42)
          .contentShape(Circle())
          .onTapGesture {
            vm.profileForm.cycleColor = CycleColor(from: cycleColor)
          }
        }
      }
    }
    .safeAreaPadding(.horizontal)
    .scrollIndicators(.hidden)
  }
  
  private var decorationSelector: some View {
    ScrollView(.horizontal) {
      LazyHStack(spacing: Defaults.spacing.horizontal.large) {
        ForEach(vm.cycleDecorations, id: \.id) { cycleDecoration in
          ZStack {
            Rectangle().stroke(
              vm.profileForm.cycleDecoration?.id == cycleDecoration.id
              ? Color.accentColor
              : Color.Surface.tertiary,
              lineWidth: vm.profileForm.cycleDecoration?.id == cycleDecoration.id
              ? 4 : 2
            )
            CycleSVGThumbnail(urlString: cycleDecoration.fileLink)
          }
          .frame(width: Defaults.bikeAvatar.customization.width, height: Defaults.bikeAvatar.customization.height)
          .contentShape(Rectangle())
          .onTapGesture {
            vm.profileForm.cycleDecoration = CycleDecoration(from: cycleDecoration)
          }
        }
      }
    }
    .safeAreaPadding(.horizontal)
    .scrollIndicators(.hidden)
  }
  
}

#Preview {
  EditProfileView()
}
