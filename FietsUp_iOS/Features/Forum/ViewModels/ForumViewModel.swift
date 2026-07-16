//
//  ForumViewModel.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 16/07/2026.
//

import Foundation

@Observable
final class ForumViewModel {
  // state
  var isLoading: Bool = false
  var isFeedbackLoading: Bool = false
  var isNewPostSheetPresented: Bool = false
  var isNewCommentSheetPresented: Bool = false
  var isNewReportSheetPresented: Bool = false
  
  // fetched data
  var categories: [ForumCategoryResponse] = []
  var category: ForumCategoryDetailedResponse? = nil
  var post: ForumPostResponse? = nil
  
  // user created data
  var newPostForm = NewPostForm()
  struct NewPostForm {
    var title: String = ""
    var content: String = ""
  }

  var newCommentForm = NewCommentForm()
  struct NewCommentForm {
    var content: String = ""
  }
  
  var newReportTarget: ReportTarget? = nil  
}
