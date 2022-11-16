//
//  CurrencyConverterVM.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 16/11/2022.
//

import Combine
import Foundation
import SwiftUI

enum ListType {
    case sell
    case buy
}

final class CurrencyConverterVM: ObservableObject {
    @Published var sellingCurrency: Currency? = nil
    @Published var buyingCurrency: Currency? = nil
    @Published var showingCurrencyListForType: ListType? = nil

    private let _currencyList: CurrentValueSubject<[Currency], Never> = .init([])

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
            .assign(to: \.sellingCurrency, on: self)
            .store(in: &store)

        _currencyList.compactMap { $0[safe: 1] }
            .receive(on: DispatchQueue.main)
            .assign(to: \.buyingCurrency, on: self)
            .store(in: &store)
    }

    public func bindingForShowingCurrencyList() -> Binding<Bool> {
        .init {
            self.showingCurrencyListForType != nil
        } set: { _ in }
    }

    public func selected(curreny: Currency) {
        switch showingCurrencyListForType {
        case .sell:
            sellingCurrency = curreny
        case .buy:
            buyingCurrency = curreny
        default: break
        }
        showingCurrencyListForType = nil
    }

    public func selectableList() -> [Currency] {
        if showingCurrencyListForType == .buy {
            return _currencyList.value.filter { $0.id != sellingCurrency?.id }
        } else {
            return _currencyList.value.filter { $0.id != buyingCurrency?.id }
        }
    }

    public func selectedCurrecny() -> Currency? {
        if showingCurrencyListForType == .buy {
            return buyingCurrency
        } else {
            return sellingCurrency
        }
    }
}
