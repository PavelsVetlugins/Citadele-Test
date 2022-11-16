//
//  HomeScene.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 16/11/2022.
//

import SwiftUI

struct HomeScene: View {
    @State var isNonCash: Bool = false
    @StateObject var vm = CurrencyConverterVM()
    @State var showingCurrencyList = false
    @State var showingRatesList = false

    var body: some View {
        VStack {
            if let sellingCurecny = vm.selectedCurrency {
                CurrencySelector(inputField: $vm.sellingCurrencyValue, actionTitle: "Sell",
                                 currencyTitle: sellingCurecny.description,
                                 currencyCode: sellingCurecny.id, onCurrecnyTap: {
                                     showingCurrencyList = true
                                 }, onEditing: { isEditing in
                                     vm.isSellingFieldEditing.send(isEditing)
                                 })
            }

            HStack {
                Spacer()
            }.frame(height: 0.5)
                .background(.gray)

            if let buyingCurecny = vm.selectedRate {
                CurrencySelector(inputField: $vm.buyingCurrencyValue, actionTitle: "Buy",
                                 currencyTitle: buyingCurecny.description,
                                 currencyCode: buyingCurecny.id, onCurrecnyTap: {
                                     showingRatesList = true
                                 }, onEditing: { isEditing in
                                     vm.isBuyingFieldEditing.send(isEditing)
                                 })
            }

            Toggle(isOn: $isNonCash, label: {
                HStack {
                    Spacer()
                    Text("Non cash rate")
                }
            })
        }
        .padding(.horizontal)
        .sheet(isPresented: $showingCurrencyList) {
            CurrencyList(selected: vm.selectedCurrency, currencies: vm.currencyList) { id in
                vm.selectedCurrency(id: id)
                showingCurrencyList = false
            }
        }
        .sheet(isPresented: $showingRatesList) {
            CurrencyList(selected: vm.selectedRate, currencies: vm.rates) { id in
                vm.selectedRate(id: id)
                showingRatesList = false
            }
        }
    }
}

struct HomeScene_Previews: PreviewProvider {
    static var previews: some View {
        HomeScene()
    }
}
