//
//  HttpRequest.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 16/11/2022.
//

import Alamofire
import Foundation

public protocol HttpRequest: Alamofire.URLRequestConvertible {
    var headers: [String: String] { get }

    var method: HTTPMethod { get }

    var url: URL? { get }

    var query: [URLQueryItem] { get }
}

extension HttpRequest {
    var baseUrl: String { Config.baseAPI }

    public var headers: [String: String] {
        return [:]
    }

    var method: HTTPMethod {
        .get
    }

    var query: [URLQueryItem] { [] }

    public func asURLRequest() -> URLRequest {
        var urlComponent = URLComponents(url: url!, resolvingAgainstBaseURL: true)
        urlComponent?.queryItems = query

        if query.count > 0 {
            urlComponent?.queryItems = query
        }

        var urlRequest = URLRequest(url: urlComponent!.url!)
        urlRequest.allHTTPHeaderFields = self.headers
        urlRequest.httpMethod = self.method.rawValue

        return urlRequest
    }
}
