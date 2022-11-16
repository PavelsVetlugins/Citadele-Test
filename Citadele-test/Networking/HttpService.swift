//
//  HttpService.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 16/11/2022.
//

import Alamofire
import Combine
import Foundation

protocol HttpServiceProviding {
    func fetchRequest<T: Decodable>(_ request: HttpRequest) -> AnyPublisher<T, Error>
}

class HttpService: HttpServiceProviding {
    // Input data
    func fetchRequest<T: Decodable>(_ request: HttpRequest) -> AnyPublisher<T, Error> {
        return Future { promise in
            AF.request(request).response { response in
                if let error = response.error {
                    promise(.failure(error))
                }

                guard let data = response.data else {
                    promise(.failure(NSError(domain: "com.empty.data", code: -1)))
                    return
                }

                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    promise(.success(response))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
