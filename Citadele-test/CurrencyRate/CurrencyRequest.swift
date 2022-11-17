//
//  CurrencyRequest.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 16/11/2022.
//

import Alamofire
import Foundation

struct CurrencyRequest: HttpRequest {
    var url: URL? {
        let path = "cimo/p/currate"
        return URL(string: path, relativeTo: URL(string: baseUrl))
    }

    var method: HTTPMethod = .post

    var query: [URLQueryItem] {
        [URLQueryItem(name: "language", value: "EN"),
         URLQueryItem(name: "location", value: "LV")]
    }
}
