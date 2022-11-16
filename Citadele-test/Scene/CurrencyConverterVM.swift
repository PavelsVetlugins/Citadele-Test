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

    @Published var useNonCashRate: Bool = true
    @Published var isNonCashAvailable: Bool = true

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
        cleanseInputBinding()

        _currencyList.compactMap { $0[safe: 0] }
            .receive(on: DispatchQueue.main)
            .assign(to: \.selectedCurrency, on: self)
            .store(in: &store)

        $selectedCurrency.compactMap { $0.rates.first }
            .receive(on: DispatchQueue.main)
            .assign(to: \.selectedRate, on: self)
            .store(in: &store)

        $selectedRate.map { $0.buyRate != nil && $0.sellRate != nil }
            .receive(on: DispatchQueue.main)
            .assign(to: \.isNonCashAvailable, on: self)
            .store(in: &store)

        $isNonCashAvailable.filter { $0 == false }
            .receive(on: DispatchQueue.main)
            .assign(to: \.useNonCashRate, on: self)
            .store(in: &store)

        let sellRate = $selectedRate.combineLatest($useNonCashRate)
            .compactMap { rate, useNonCashRate -> Double? in
                guard let sell = useNonCashRate ? rate.sellTransfer : rate.sellRate,
                      let sellValue = Double(sell) else { return nil }
                if self.selectedCurrency.reverseUsdQuot, rate.currency == "USD" {
                    return 1 / sellValue
                }
                return sellValue
            }
            .share()

        let sellingCurrencyValidChange = $sellingCurrencyValue
            .withLatestFrom(isBuyingFieldEditing)
            .filter { $1 == false }
            .map { value, _ in value }
            .compactMap { Double($0) }
            .share()

        let triggerSellCalculation = Publishers.CombineLatest3(sellingCurrencyValidChange, $selectedCurrency, sellRate)
            .share()

        triggerSellCalculation
            .map { amount, _, rate in
                CurrencyFormatter.asCurrency(price: amount / rate) ?? ""
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.buyingCurrencyValue, on: self)
            .store(in: &store)

        let buyingCurrencyValidChange = $buyingCurrencyValue
            .withLatestFrom(isSellingFieldEditing)
            .filter { $1 == false }
            .map { value, _ in value }
            .compactMap { Double($0) }
            .share()

        let triggerBuyCalculation = buyingCurrencyValidChange.withLatestFrom(sellRate)
            .share()

        triggerBuyCalculation
            .map { amount, rate in
                CurrencyFormatter.asCurrency(price: amount * rate) ?? ""
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.sellingCurrencyValue, on: self)
            .store(in: &store)
    }

    private func cleanseInputBinding() {
        // SwiftUI does not provid ability to edit user input on the fly, hecne its the only way to cleanse user input using SwiftUI TextView.
        $sellingCurrencyValue
            .withLatestFrom(isSellingFieldEditing)
            .filter { $1 == true }
            .map { value, _ in value }
            .debounce(for: .milliseconds(10), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] value in
                guard let self else { return }

                let cleansedValue = self.cleanseInput(input: value)
                if value != cleansedValue {
                    self.sellingCurrencyValue = cleansedValue
                }
            })
            .store(in: &store)

        $buyingCurrencyValue
            .withLatestFrom(isBuyingFieldEditing)
            .filter { $1 == true }
            .map { value, _ in value }
            .debounce(for: .milliseconds(10), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] value in
                guard let self else { return }

                let cleansedValue = self.cleanseInput(input: value)
                if value != cleansedValue {
                    self.buyingCurrencyValue = cleansedValue
                }
            })
            .store(in: &store)
    }

    private func cleanseInput(input: String) -> String {
        var cleansedValue = input
        cleansedValue = cleansedValue.filter("0123456789.".contains)
        if cleansedValue.starts(with: ".") {
            cleansedValue.removeFirst()
        }
        if cleansedValue.filter({ $0 == "." }).count > 1,
           let index = cleansedValue.lastIndex(of: ".")
        {
            cleansedValue.remove(at: index)
        }

        return cleansedValue
    }

    public func selectedCurrency(id: String) {
        selectedCurrency = currencyList.first { $0.id == id } ?? .empty()
    }

    public func selectedRate(id: String) {
        selectedRate = selectedCurrency.rates.first { $0.id == id } ?? .empty()
    }
}
