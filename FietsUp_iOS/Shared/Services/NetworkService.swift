//
//  NetworkService.swift
//  FietsUp_iOS
//
//  Created by Anne Ferret on 04/05/2026.
//

import Foundation

final class NetworkService {
  static let shared = NetworkService()
  private init() {}
  private let apiBaseURL = ConfigService.apiBaseURL
  
  private func buildRequest(
    endpoint: String,
    method: HTTPMethod,
    body: Encodable? = nil,
    requiresAuth: Bool
  ) throws -> URLRequest {
    guard let url = URL(string: apiBaseURL + endpoint) else {
      throw NetworkError.invalidURL
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    if requiresAuth {
      if let token = try KeychainService.shared.getToken() {
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
      } else {
        throw NetworkError.unauthorized
      }
    }
    
    if let body = body {
      let encoder = JSONEncoder()
      encoder.keyEncodingStrategy = .convertToSnakeCase
      encoder.dateEncodingStrategy = .iso8601
      request.httpBody = try encoder.encode(body)
    }
    
    return request
  }
  
  private func validateResponse(_ response: URLResponse) throws -> HTTPURLResponse {
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.invalidResponse
    }
    
    switch httpResponse.statusCode {
      case 200...299: return httpResponse
      case 400: throw NetworkError.badRequest
      case 401:
        try AuthService.shared.logout()
        throw NetworkError.unauthorized
      case 403: throw NetworkError.forbidden
      case 404: throw NetworkError.notFound
      case 409: throw NetworkError.conflict
      case 500...599: throw NetworkError.serverIssues
      default: throw NetworkError.serverError(statusCode: httpResponse.statusCode)
    }
  }
  
  func request<T: Decodable>(
    endpoint: String,
    method: HTTPMethod,
    body: Encodable? = nil,
    requiresAuth: Bool = false
  ) async throws -> T {
    let urlRequest = try buildRequest(
      endpoint: endpoint,
      method: method,
      body: body,
      requiresAuth: requiresAuth
    )
    
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    _ = try validateResponse(response)
    
    guard !data.isEmpty else { throw NetworkError.noData }
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601
    
    do {
      return try decoder.decode(T.self, from: data)
    } catch {
      print("DECODING ERROR DETAILS:")
      print("Raw data: \(String(data: data, encoding: .utf8) ?? "Unable to convert to string")")
      print("Actual error: \(error)")
      
      if let decodingError = error as? DecodingError {
        switch decodingError {
          case .keyNotFound(let key, let context):
            print("Missing key: '\(key.stringValue)' at path: \(context.codingPath)")
          case .typeMismatch(let type, let context):
            print("Type mismatch for type '\(type)' at path: \(context.codingPath)")
          case .valueNotFound(let type, let context):
            print("Value not found for type '\(type)' at path: \(context.codingPath)")
          case .dataCorrupted(let context):
            print("Data corrupted: \(context.debugDescription)")
          @unknown default:
            print("Unknown decoding error")
        }
      }
      
      throw NetworkError.decodingError
    }
  }
  
  func get<T: Decodable>(endpoint: String, requiresAuth: Bool = false) async throws -> T {
    try await request(endpoint: endpoint, method: .get, requiresAuth: requiresAuth)
  }
  
  func post<T: Decodable>(endpoint: String, body: Encodable, requiresAuth: Bool = false) async throws -> T {
    try await request(endpoint: endpoint, method: .post, body: body, requiresAuth: requiresAuth)
  }
  
  func patch<T: Decodable>(endpoint: String, body: Encodable, requiresAuth: Bool = true) async throws -> T {
    try await request(endpoint: endpoint, method: .patch, body: body, requiresAuth: requiresAuth)
  }
  
  func delete(endpoint: String, requiresAuth: Bool = true) async throws {
    let urlRequest = try buildRequest(
      endpoint: endpoint,
      method: .delete,
      requiresAuth: requiresAuth
    )
    
    let (_, response) = try await URLSession.shared.data(for: urlRequest)
    _ = try validateResponse(response)
  }
}

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case patch = "PATCH"
  case delete = "DELETE"
}

enum NetworkError: Error, LocalizedError {
  case invalidURL
  case invalidResponse
  case badRequest
  case unauthorized
  case forbidden
  case notFound
  case conflict
  case serverIssues
  case serverError(statusCode: Int)
  case decodingError
  case noData
  
  var errorDescription: String? {
    switch self {
      case .invalidURL:
        return String(localized: "network.error.invalidURL")
      case .invalidResponse:
        return String(localized: "network.error.invalidResponse")
      case .badRequest:
        return String(localized: "network.error.badRequest")
      case .unauthorized:
        return String(localized: "network.error.unauthorized")
      case .forbidden:
        return String(localized: "network.error.forbidden")
      case .notFound:
        return String(localized: "network.error.notFound")
      case .conflict:
        return String(localized: "network.error.conflict")
      case .serverIssues:
        return String(localized: "network.error.serverIssues")
      case .serverError(let statusCode):
        return String(localized: "network.error.serverError \(statusCode)")
      case .decodingError:
        return String(localized: "network.error.decodingError")
      case .noData:
        return String(localized: "network.error.noData")
    }
  }
}
