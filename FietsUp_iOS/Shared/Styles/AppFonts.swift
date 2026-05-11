//
//  Fonts.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 11/05/2026.
//

import SwiftUI

extension Font {
  private static let regular = "HelveticaNeue"
  private static let bold = "HelveticaNeue-Bold"
  
  static var body: Font { .custom(regular, size: 17, relativeTo: .body) }
  static var title: Font { .custom(bold, size: 32, relativeTo: .title) }
  static var title2: Font { .custom(bold, size: 24, relativeTo: .title2) }
  static var title3: Font { .custom(bold, size: 18, relativeTo: .title3) }
  static var callout: Font { .custom(regular, size: 15, relativeTo: .callout) }
  static var caption: Font { .custom(bold, size: 14, relativeTo: .caption) }
  static var caption2: Font { .custom(regular, size: 13, relativeTo: .caption2) }
  static var data: Font { .custom(bold, size: 36, relativeTo: .largeTitle) }
  static var data2: Font { .custom(bold, size: 26, relativeTo: .title) }
}
