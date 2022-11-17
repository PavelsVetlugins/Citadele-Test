//
//  CurrencyRateServiceMock.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 17/11/2022.
//

import Combine
import Foundation

class CurrencyRateServiceMock: CurrencyRateServiceProviding {
    var ratesResponse: () -> CurrateResponse = {
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "CurRateResponse", ofType: "json")!)
        let data = try! Data(contentsOf: url)
        let response = try! JSONDecoder().decode(CurrateResponse.self, from: data)
        return response
    }

    func fetchRates() -> AnyPublisher<CurrateResponse, Error> {
        return Result.Publisher(.success(ratesResponse())).eraseToAnyPublisher()
    }
}
