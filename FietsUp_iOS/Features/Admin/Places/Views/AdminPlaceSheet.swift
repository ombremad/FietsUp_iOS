//
//  AdminPlaceSheet.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/07/2026.
//

import SwiftUI

struct AdminPlaceSheet: View {
  @Environment(AdminPlacesViewModel.self) private var vm
  @Environment(\.dismiss) private var dismiss
  
  enum Field: Hashable {
    case latitude, longitude
  }
  @FocusState private var focusedField: Field?
  
  var body: some View {
    @Bindable var vm = vm
    Form {
      AppFormSection("admin.place.mandatorySection") {
        LabeledContent("admin.place.name") {
          TextField("", text: $vm.placeForm.name)
        }
        LabeledContent("admin.place.categories") {
          NavigationLink {
            PlaceCategoriesPickerView(
              allCategories: vm.categories,
              selectedIds: Binding(
                get: { Set(vm.placeForm.categories.map(\.id)) },
                set: { newIds in
                  vm.placeForm.categories = vm.categories.filter { newIds.contains($0.id) }
                }
              )
            )
          } label: {
            Text(vm.placeForm.categories.map(\.name).joined(separator: ", "))
              .foregroundStyle(Color.Text.secondary)
          }
        }
        Toggle("admin.place.useCurrentLocation", isOn: $vm.placeForm.useCurrentLocation)
        if !vm.placeForm.useCurrentLocation {
          LabeledContent("admin.place.latitude") {
            TextField("", value: $vm.placeForm.latitude, format: .number.precision(.fractionLength(0...6)))
              .keyboardType(.decimalPad)
              .focused($focusedField, equals: .latitude)
          }.disabled(vm.placeForm.useCurrentLocation)
          LabeledContent("admin.place.longitude") {
            TextField("", value: $vm.placeForm.longitude, format: .number.precision(.fractionLength(0...6)))
              .keyboardType(.decimalPad)
              .focused($focusedField, equals: .longitude)
          }.disabled(vm.placeForm.useCurrentLocation)
        }
      }
      AppFormSection("admin.place.optionalSection") {
        LabeledContent("admin.place.address") {
          TextField("", text: $vm.placeForm.address)
        }
        LabeledContent("admin.place.zipCode") {
          TextField("", text: $vm.placeForm.zipCode)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
        }
        LabeledContent("admin.place.city") {
          TextField("", text: $vm.placeForm.city)
        }
        LabeledContent("admin.place.country") {
          TextField("", text: $vm.placeForm.country)
        }
        LabeledContent("admin.place.phoneNumber") {
          TextField("", text: $vm.placeForm.phoneNumber)
            .keyboardType(.phonePad)
        }
        LabeledContent("admin.place.email") {
          TextField("", text: $vm.placeForm.email)
            .keyboardType(.emailAddress)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
        }
        LabeledContent("admin.place.website") {
          TextField("", text: $vm.placeForm.website)
            .keyboardType(.URL)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
        }
        LabeledContent("admin.place.otherDetails") {
          TextField("", text: $vm.placeForm.otherDetails)
        }
      }
    }
    .foregroundStyle(Color.Text.primary)
    .background { Color.Surface.background.ignoresSafeArea() }
    .labeledContentStyle(AppLabeledContent())
    .scrollContentBackground(.hidden)
    .navigationTitle("admin.place.title")
    .navigationBarTitleDisplayMode(.inline)
    .presentationDetents([.large])
  
    .toolbar {
      if focusedField == .latitude || focusedField == .longitude {
        ToolbarItemGroup(placement: .keyboard) {
          Spacer()
          Button("admin.place.negativeButton", systemImage: "plusminus") {
            switch focusedField {
              case .latitude: vm.placeForm.latitude *= -1
              case .longitude: vm.placeForm.longitude *= -1
              case nil: break
            }
          }
        }
      }
      ToolbarItem(placement: .confirmationAction) {
        Button("common.confirm", systemImage: "arrow.up", role: .confirm) {
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
      ToolbarItem(placement: .cancellationAction) {
        Button("common.cancel", systemImage: "xmark", role: .cancel) { dismiss() }
      }
    }
  }
}
