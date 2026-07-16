//
//  DangersViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 08/06/2026.
//

import Foundation
import CoreLocation

@Observable
final class DangersViewModel {
  // state
  var isLoading: Bool = false
  var isFeedbackLoading: Bool = false
  var isNewPostSheetPresented: Bool = false
  var isNewCommentSheetPresented: Bool = false
  
  // location
  let locationService = LocationService.shared
  var hasLocation: Bool { latitude != nil && longitude != nil }
  var latitude: Double? { locationService.latitude }
  var longitude: Double? { locationService.longitude }
  var locationStatus: CLAuthorizationStatus { locationService.authorizationStatus }
  var postApproximateLocation: String? = nil
  
  // fetched data
  var posts: [DangerPostShortResponse] = []
  var post: DangerPostResponse? = nil
  var availableCategories: [DangerCategoryResponse] = []

  // user created data
  var newPostForm = NewPostForm()
  struct NewPostForm {
    var title: String = ""
    var content: String = ""
    var categoryId: UUID?
    var approximateLocation: String?
  }
  
  var newCommentForm = NewCommentForm()
  struct NewCommentForm {
    var content: String = ""
  }

  var newReportTarget: ReportTarget? = nil
}
