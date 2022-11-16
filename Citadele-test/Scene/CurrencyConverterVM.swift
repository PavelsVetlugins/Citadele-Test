//
//  CurrencyConverterVM.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 16/11/2022.
//

import Combine
import Foundation

final class CurrencyConverterVM: ObservableObject {
    @Published var sellingCurrency: Currency? = nil
    @Published var buyingCurrency: Currency? = nil

    private let currencyList: CurrentValueSubject<[Currency], Never> = .init([])

    var store = Set<AnyCancellable>()

    init() {
        bind()

        let currateRequest: AnyPublisher<CurrateResponse, Error> = HttpService().fetchRequest(CurrencyRequest())

        currateRequest.sink(receiveCompletion: { error in
            print("+++ \(error)")
        }, receiveValue: { result in
            self.currencyList.send(result.data)
        })
        .store(in: &store)
    }

    private func bind() {
        currencyList.compactMap { $0[safe: 0] }
            .receive(on: DispatchQueue.main)
            .assign(to: \.sellingCurrency, on: self)
            .store(in: &store)

        currencyList.compactMap { $0[safe: 1] }
            .receive(on: DispatchQueue.main)
            .assign(to: \.buyingCurrency, on: self)
            .store(in: &store)
    }
}
