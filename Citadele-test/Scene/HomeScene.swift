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

    var body: some View {
        VStack {
            if let sellingCurecny = vm.sellingCurrency {
                CurrencySelector(inputField: $vm.sellingCurrencyValue,
                                 currencyTitle: sellingCurecny.description,
                                 currencyCode: sellingCurecny.id, onCurrecnyTap: {
                                     vm.showingCurrencyListForType = .sell
                                 }, onEditing: { isEditing in
                                     vm.isSellingFieldEditing.send(isEditing)
                                 })
            }

            HStack {
                Spacer()
            }.frame(height: 0.5)
                .background(.gray)

            if let buyingCurecny = vm.buyingCurrency {
                CurrencySelector(inputField: $vm.buyingCurrencyValue,
                                 currencyTitle: buyingCurecny.description,
                                 currencyCode: buyingCurecny.id, onCurrecnyTap: {
                                     vm.showingCurrencyListForType = .buy
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
        .sheet(isPresented: vm.bindingForShowingCurrencyList()) {
            CurrencyList(selected: vm.selectedCurrecny(), currencies: vm.selectableList()) { currency in
                vm.selected(curreny: currency)
            }
        }
    }
}

struct HomeScene_Previews: PreviewProvider {
    static var previews: some View {
        HomeScene()
    }
}
