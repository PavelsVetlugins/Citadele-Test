//
//  CurrencyRateService.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 17/11/2022.
//

import Combine
import Foundation

protocol CurrencyRateServiceProviding {
    func fetchRates() -> AnyPublisher<CurrateResponse, Error>
}

class CurrencyRateService: CurrencyRateServiceProviding {
    let httpService: HttpServiceProviding

    init(httpService: HttpServiceProviding = HttpService()) {
        self.httpService = httpService
    }

    func fetchRates() -> AnyPublisher<CurrateResponse, Error> {
        return httpService.fetchRequest(CurrencyRequest())
    }
}
