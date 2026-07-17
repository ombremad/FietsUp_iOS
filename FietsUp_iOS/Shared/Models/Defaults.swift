//
//  Defaults.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 15/07/2026.
//

import Foundation

enum Defaults {
  enum values {
    static let banEndDate: Date = .now.addingTimeInterval(60 * 60 * 24 * 7) // one week
  }
  
  enum pagination {
    static let maxItems: Int = 20
    static let metadata: PageMetadata = .init(page: 1, per: maxItems, total: 0)
  }

  enum spacing {
    enum horizontal {
      static let xsmall: CGFloat = 4
      static let small: CGFloat = 6
      static let medium: CGFloat = 12
      static let large: CGFloat = 24
      static let xlarge: CGFloat = 36
    }
    enum vertical {
      static let xsmall: CGFloat = 4
      static let small: CGFloat = 8
      static let medium: CGFloat = 16
      static let large: CGFloat = 24
      static let xlarge: CGFloat = 42
    }
  }
  
  enum padding {
    static let xxsmall: CGFloat = 2
    static let xsmall: CGFloat = 8
    static let small: CGFloat = 12
    static let medium: CGFloat = 20
    static let large: CGFloat = 32
    static let xlarge: CGFloat = 42
  }
    
  enum radius {
    static let regular: CGFloat = 10
    static let large: CGFloat = 18
  }
  
  enum bikeAvatar {
    enum aspect {
      static let width: CGFloat = 121
      static let height: CGFloat = 81
      static let ratio: CGFloat = width / height
    }
    enum small {
      static let width: CGFloat = 25
      static let height: CGFloat = 16
    }
    enum big {
      static let width: CGFloat = 46
      static let height: CGFloat = 30
    }
    enum customization {
      static let width: CGFloat = 180
      static let height: CGFloat = 120
    }
  }
}
