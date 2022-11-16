//
//  CurrencyConverterVM.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 16/11/2022.
//

import Combine
import Foundation
import SwiftUI

final class CurrencyConverterVM: ObservableObject {
    @Published var selectedCurrency: Currency = .empty()
    @Published var sellingCurrencyValue: String = ""
    public var isSellingFieldEditing: CurrentValueSubject<Bool, Never> = .init(false)

    @Published var selectedRate: Rate = .empty()
    @Published var buyingCurrencyValue: String = ""
    public var isBuyingFieldEditing: CurrentValueSubject<Bool, Never> = .init(false)

    private let _currencyList: CurrentValueSubject<[Currency], Never> = .init([])
    public var currencyList: [Currency] { _currencyList.value }
    public var rates: [Rate] { selectedCurrency.rates }

    var store = Set<AnyCancellable>()

    init() {
        bind()

        let currateRequest: AnyPublisher<CurrateResponse, Error> = HttpService().fetchRequest(CurrencyRequest())

        currateRequest.sink(receiveCompletion: { error in
            print("+++ \(error)")
        }, receiveValue: { result in
            self._currencyList.send(result.data)
        })
        .store(in: &store)
    }

    private func bind() {
        _currencyList.compactMap { $0[safe: 0] }
            .receive(on: DispatchQueue.main)
            .assign(to: \.selectedCurrency, on: self)
            .store(in: &store)

        $selectedCurrency.compactMap { $0.rates.first }
            .receive(on: DispatchQueue.main)
            .assign(to: \.selectedRate, on: self)
            .store(in: &store)

        $sellingCurrencyValue
            .withLatestFrom(isBuyingFieldEditing)
            .filter { $1 == false }
            .map { input, _ in
                "\((Decimal(string: input) ?? 0) * 2)"
            }
            .assign(to: \.buyingCurrencyValue, on: self)
            .store(in: &store)

        $buyingCurrencyValue
            .withLatestFrom(isSellingFieldEditing)
            .filter { $1 == false }
            .map { input, _ in
                "\((Decimal(string: input) ?? 0) * 2)"
            }
            .assign(to: \.sellingCurrencyValue, on: self)
            .store(in: &store)
    }

    public func selectedCurrency(id: String) {
        selectedCurrency = currencyList.first { $0.id == id } ?? .empty()
    }

    public func selectedRate(id: String) {
        selectedRate = selectedCurrency.rates.first { $0.id == id } ?? .empty()
    }
}
