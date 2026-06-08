//
//  Placeholders.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 08/06/2026.
//

import Foundation

enum Placeholder {
  enum User {
    static let firstName = "Paul"
    static let lastName = "Jean-Paul"
    static let nickname = "veliste_du_31"
    static let email = "jeanpaulveliste@example.com"
    static let bio = "Je fais du vélo et c'est ma grande joie"
    static let streak = 12
    static let daysSinceSignup = 200
    static let totalElapsedDistance = 42_000
  }
  
  enum ForumPost {
    static let title = "Qui pour aller se balader les dimanches à Toulouse ?"
    static let content = """
Coucou tout le monde ! Je débute en ville, et j’aimerais trouver des partenaires de vélo avec qui aller faire des promenades faciles les prochaines semaines, au moins le temps de m’habituer.
Évidemment, le but sera d’apprendre, chacun·e à son rythme ! Et pourquoi pas d’accueillir encore plus de débutants quand je me sentirai un peu plus à l’aise moi-même ;-) 
Alors ? On s’organise les Toulousain·es sur·es ??
"""
  }
  
  enum ForumComment {
    static let content = "Je suis entièrement d'accord !"
  }
  
  enum ForumCategory {
    static let name = "Le coin des débutant·es"
    static let content = "Présentation, premiers trajets, appréhensions, bonnes habitudes, conseils..."
  }
  
  enum DangerPost {
    static let title = "Voiture garée sur la piste cyclable"
    static let content = """
Quartier Minimes, très dangereux !
Le chauffeur au téléphone s’est arrêté portière ouverte sans même regarder. Il y est toujours garé à l’heure où j’écris ce signalement. Attention, il a également tendance à être agressif, prenez soin de vous.
À l’angle de la pharmacie et de l’entrée du métro.
"""
  }
  
  enum DangerCategory {
    static let name = "Véhicule gênant"
    static let iconName = "car.top.radiowaves.rear.left.car.top.front"
  }
  
  enum Place {
    static let name = "VélÔToulouse"
    static let content = "En plein air, accessible 24h/24"
  }
  
  enum PlaceCategory {
    static let name = "Point self-service"
    static let iconName = "screwdriver"
  }
  
  enum Dates {
    static let recent = Date(timeIntervalSinceNow: -12000)
  }
  
  enum Numbers {
    static let like = 42
    static let count = 12
  }
}

extension UserResponse {
  static let placeholder = UserResponse(
    firstName: Placeholder.User.firstName,
    lastName: Placeholder.User.lastName,
    nickname: Placeholder.User.nickname,
    email: Placeholder.User.email,
    bio: Placeholder.User.bio,
    streak: Placeholder.User.streak,
    daysSinceSignup: Placeholder.User.daysSinceSignup,
    totalElapsedDistance: Placeholder.User.totalElapsedDistance
  )
}

extension UserPublicResponse {
  static let placeholder = UserPublicResponse(
    id: UUID(),
    nickname: Placeholder.User.nickname,
    streak: Placeholder.User.streak,
    daysSinceSignup: Placeholder.User.daysSinceSignup,
    totalElapsedDistance: Placeholder.User.totalElapsedDistance,
    bio: Placeholder.User.bio
  )
}

extension User {
  static let placeholder = User(with: .placeholder)
}

extension ForumPostResponse {
  static let placeholder = ForumPostResponse(
    id: UUID(),
    title: Placeholder.ForumPost.title,
    content: Placeholder.ForumPost.content,
    user: UserPublicResponse.placeholder,
    creationDate: Placeholder.Dates.recent,
    likeCount: Placeholder.Numbers.like,
    likedByUser: false,
    favedByUser: true,
    comments: [ForumCommentResponse.placeholder, ForumCommentResponse.placeholder])
}

extension ForumCommentResponse {
  static let placeholder = ForumCommentResponse(
    id: UUID(),
    content: Placeholder.ForumComment.content,
    user: UserPublicResponse.placeholder,
    creationDate: Placeholder.Dates.recent,
    likeCount: Placeholder.Numbers.like,
    likedByUser: false,
    favedByUser: true
  )
}

extension ContentCard {
  static let forumCategoryPlaceholder = ContentCard(
    contentType: .forumCategory,
    title: Placeholder.ForumCategory.name,
    content: Placeholder.ForumCategory.content,
    footerData: Placeholder.Numbers.count,
    date: Placeholder.Dates.recent
  )
  
  static let forumPostPlaceholder = ContentCard(
    contentType: .forumPost,
    flairs: [CardFlair(name: Placeholder.User.nickname, iconName: "person.fill")],
    title: Placeholder.ForumPost.title,
    content: Placeholder.ForumPost.content,
    footerData: Placeholder.Numbers.count,
    date: Placeholder.Dates.recent
  )
  
  static let placePlaceholder = ContentCard(
    contentType: .place,
    flairs: [
      CardFlair(name: Placeholder.PlaceCategory.name, iconName: Placeholder.PlaceCategory.iconName),
      CardFlair(name: Placeholder.PlaceCategory.name, iconName: Placeholder.PlaceCategory.iconName),
    ],
    title: Placeholder.Place.name,
    content: Placeholder.Place.content,
    footerData: Placeholder.Numbers.count,
    date: Placeholder.Dates.recent
  )
  
  static let dangerPostPlaceholder = ContentCard(
    contentType: .dangerPost,
    flairs: [CardFlair(name: Placeholder.DangerCategory.name, iconName: Placeholder.DangerCategory.iconName)],
    title: Placeholder.DangerPost.title,
    content: Placeholder.DangerPost.content,
    footerData: Placeholder.Numbers.count,
    date: Placeholder.Dates.recent
  )
}

extension ContentComponent {
  static let bigPlaceholder = ContentComponent(
    size: .big,
    title: Placeholder.ForumPost.title,
    content: Placeholder.ForumPost.content,
    date: Placeholder.Dates.recent,
    user: UserPublicResponse.placeholder,
  )
  static let smallPlaceholder = ContentComponent(
    size: .small,
    title: Placeholder.ForumPost.title,
    content: Placeholder.ForumPost.content,
    date: Placeholder.Dates.recent,
    user: UserPublicResponse.placeholder,
  )
}

extension UserPublicCard {
  static let bigPlaceholder = UserPublicCard(
    user: UserPublicResponse.placeholder,
    date: Placeholder.Dates.recent,
    size: .big
  )
  
  static let smallPlaceholder = UserPublicCard(
    user: UserPublicResponse.placeholder,
    date: Placeholder.Dates.recent,
    size: .small
  )
}
