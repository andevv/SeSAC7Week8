//
//  NetworkError.swift
//  SeSACRxThreads
//
//  Created by andev on 8/18/25.
//

import Foundation

enum NetworkError: Int, Error {
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case serverError = 500
    case unknown = 503
    
    var userResponse: String {
        switch self {
        case .badRequest:
            "Bad Request 입니다."
        case .unauthorized:
            "Unauthorized 입니다."
        case .forbidden:
            "forbidden 입니다."
        case .notFound:
            "notFound 입니다."
        case .serverError:
            "serverError 입니다."
        case .unknown:
            "unknown 입니다."
        }
    }
}
