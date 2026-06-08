//
//  SinglePlaceSheet.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 03/06/2026.
//

import SwiftUI

struct SinglePlaceSheet: View {
  @Environment(PlacesViewModel.self) var vm
  @Environment(\.openURL) private var openURL
  @State private var selectedDetent: PresentationDetent = .medium
      
  var body: some View {
    List {
      if vm.selectedPlace != nil {
        tagsSection
        infoSection
      } else {
        Text("error")
      }
    }
    .listStyle(.inset)
    .labeledContentStyle(DetailRowStyle())
    .foregroundStyle(Color.Text.primary)
    .scrollContentBackground(.hidden)
    
    .presentationDetents([.fraction(0.10), .medium, .large], selection: $selectedDetent)
    .presentationDragIndicator(.visible)
    .interactiveDismissDisabled()
    .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.10)))
    .presentationBackground {
      if selectedDetent == .large {
        Color.Surface.background
      } else {
        Color.clear
      }
    }
    
    .navigationTitle(vm.selectedPlace?.name ?? "common.loading")
    .navigationBarTitleDisplayMode(.inline)
    
    .toolbar {
      ToolbarItem(placement: .cancellationAction) {
        Button("common.cancel", systemImage: "chevron.backward", role: .cancel) {
          vm.showPlacesSheet()
        }
      }
    }
  }
  
  @ViewBuilder
  private var tagsSection: some View {
    if let place = vm.selectedPlace {
      let distance: Int = distanceBetweenTwoPoints(
        lat1: vm.latitude ?? 0,
        lon1: vm.longitude ?? 0,
        lat2: place.latitude,
        lon2: place.longitude
      )
      
      Section {
        FlowLayout(spacing: 8) {
          ForEach(place.categories) { category in
            HStack {
              Image(systemName: category.iconName)
              Text(category.name)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .foregroundStyle(Color.Text.Contrasted.primary)
            .background(Color.Button.primary)
            .clipShape(Capsule())
          }
          HStack {
            Image(systemName: "signpost.right")
            Text("place.distanceInMeters **\(distance)**")
          }
          .padding(.horizontal, 12)
          .padding(.vertical, 6)
          .foregroundStyle(Color.Text.secondary)
          .background(Color.Surface.secondary)
          .clipShape(Capsule())
        }
        .lineLimit(1)
        .font(.caption2).bold()
        .listRowSeparator(.hidden)
      }
      .listRowBackground(Color.clear)
    }
  }
  
  @ViewBuilder
  private var infoSection: some View {
    if let place = vm.selectedPlace {
      var fullAddress: String? {
        let zipAndCity = [place.zipCode, place.city].compactMap { $0 }.joined(separator: " ")
        let parts = [
          place.address,
          zipAndCity.isEmpty ? nil : zipAndCity,
          place.country
        ].compactMap { $0 }
        return parts.isEmpty ? nil : parts.joined(separator: "\n")
      }
      
      Section {
        if let fullAddress {
          if let url = URL(string: "https://maps.apple.com/?q=\(fullAddress)") {
            Button { openURL(url) } label: {
              LabeledContent("place.label.address", value: fullAddress)
            }
          }
        }
        if let details = place.otherDetails {
          LabeledContent("place.label.details", value: details)
        }
        if let phone = place.phoneNumber,
           let url = URL(string: "tel://\(phone)") {
          Button { openURL(url) } label: {
            LabeledContent("place.label.phone", value: phone)
          }
        }
        if let email = place.email,
           let url = URL(string: "mailto:\(email)") {
          Button { openURL(url) } label: {
            LabeledContent("place.label.email", value: email)
          }
        }
        if let website = place.website,
           let url = URL(string: website) ?? URL(string: "https://\(website)") {
          Button { openURL(url) } label: {
            LabeledContent("place.label.website", value: website)
          }
        }
        if let date = place.lastUpdateDate ?? place.creationDate {
          LabeledContent("place.label.lastUpdated", value: date, format: .dateTime.day().month().year())
        }
      }
      .buttonStyle(.plain)
    }
  }
  
  struct DetailRowStyle: LabeledContentStyle {
    func makeBody(configuration: Configuration) -> some View {
      HStack(alignment: .top) {
        configuration.label
          .foregroundStyle(Color.Text.secondary)
        Spacer()
        configuration.content
          .foregroundStyle(Color.Text.primary)
          .multilineTextAlignment(.trailing)
      }
      .font(.body)
    }
  }
}
