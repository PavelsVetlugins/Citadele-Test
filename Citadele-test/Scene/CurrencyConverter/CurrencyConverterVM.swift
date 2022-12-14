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
    private var store = Set<AnyCancellable>()

    @Published var selectedCurrency: Currency = .empty()
    @Published var sellingCurrencyValue: String = ""
    public var isSellingFieldEditing: CurrentValueSubject<Bool, Never> = .init(false)

    @Published var selectedRate: Rate = .empty()
    @Published var buyingCurrencyValue: String = ""
    public var isBuyingFieldEditing: CurrentValueSubject<Bool, Never> = .init(false)

    @Published var isLoading: Bool = true
    @Published var useNonCashRate: Bool = true
    @Published var isCashRateAvailable: Bool = true
    @Published var isCurrencyOnTop: Bool = true

    private let _currencyList: CurrentValueSubject<[Currency], Never> = .init([])
    public var currencyList: [Currency] { _currencyList.value }
    public var rates: [Rate] { selectedCurrency.rates }

    // MARK: - Dependancies

    private let alertManager: AlertManager
    private let currancyRateService: CurrencyRateServiceProviding

    init(diContainer: DIContainerProtocol = DIContainer.shared) {
        self.alertManager = diContainer.resolve()!
        self.currancyRateService = diContainer.resolve()!

        bind()
        fetchRates()
    }

    // MARK: - Binding

    private func bind() {
        cleanseInputBinding()
        calculateRateBinding()

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
            .assign(to: \.isCashRateAvailable, on: self)
            .store(in: &store)

        $isCashRateAvailable.filter { $0 == false }
            .map { !$0 }
            .receive(on: DispatchQueue.main)
            .assign(to: \.useNonCashRate, on: self)
            .store(in: &store)
    }

    private func calculateRateBinding() {
        let sellRate = $selectedRate.combineLatest($useNonCashRate, $isCurrencyOnTop)
            .compactMap { [weak self] rate, useNonCashRate, isSelling -> RateCalculator? in
                guard let self,
                      let sell = useNonCashRate ? rate.buyTransfer : rate.buyRate,
                      let buy = useNonCashRate ? rate.sellTransfer : rate.sellRate,
                      let buyValue = Double(buy),
                      let sellValue = Double(sell) else { return nil }

                let rateCalculator = RateCalculator(sellRate: sellValue,
                                                    buyRate: buyValue,
                                                    isSelling: isSelling,
                                                    isReverseUsdQuot: self.selectedCurrency.reverseUsdQuot,
                                                    isUSDCurrency: rate.currency == "USD")
                return rateCalculator
            }
            .share()

        let sellingCurrencyValidChange = $sellingCurrencyValue
            .withLatestFrom(isBuyingFieldEditing)
            .filter { $1 == false }
            .map { value, _ in value }
            .map { Double($0) ?? 0 }
            .share()

        let triggerSellCalculation = Publishers.CombineLatest3(sellingCurrencyValidChange, $selectedCurrency, sellRate)
            .share()

        triggerSellCalculation
            .map { amount, _, calculator in
                calculator.calculateRate(amount: amount)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.buyingCurrencyValue, on: self)
            .store(in: &store)

        let buyingCurrencyValidChange = $buyingCurrencyValue
            .withLatestFrom(isSellingFieldEditing)
            .filter { $1 == false }
            .map { value, _ in value }
            .map { Double($0) ?? 0 }
            .share()

        let triggerBuyCalculation = buyingCurrencyValidChange.withLatestFrom(sellRate)
            .share()

        triggerBuyCalculation
            .map { amount, calculator in
                calculator.calculateRate(amount: amount)
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

    // MARK: - Private

    private func fetchRates() {
        isLoading = true

        currancyRateService.fetchRates()
            .sink(receiveCompletion: { [weak self] result in
                if case .failure = result {
                    self?.alertManager.presentAlert(infoAlert: NetworkError(onRetry: { [weak self] in
                        self?.fetchRates()
                    }))
                }
            }, receiveValue: { [weak self] result in
                self?._currencyList.send(result.data)
                self?.isLoading = false
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
}

// MARK: - Public

extension CurrencyConverterVM {
    public func selectedCurrency(id: String) {
        selectedCurrency = currencyList.first { $0.id == id } ?? .empty()
    }

    public func selectedRate(id: String) {
        selectedRate = selectedCurrency.rates.first { $0.id == id } ?? .empty()
    }
}
