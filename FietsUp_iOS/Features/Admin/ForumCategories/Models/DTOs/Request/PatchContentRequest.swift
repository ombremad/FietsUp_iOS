//
//  PatchContentRequest.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 08/07/2026.
//

import Foundation

struct PatchContentRequest: Encodable {
  let title: String?
  let content: String?
  
  init(title: String?, content: String?) {
    self.title = title ?? nil
    self.content = content ?? nil
  }
}
