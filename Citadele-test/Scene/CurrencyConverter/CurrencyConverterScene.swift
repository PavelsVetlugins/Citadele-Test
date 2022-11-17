//
//  HomeScene.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 16/11/2022.
//

import SwiftUI

struct CurrencyConverterScene: View {
    @ObservedObject var vm: CurrencyConverterVM
    @State var showingCurrencyList = false
    @State var showingRatesList = false

    var body: some View {
        VStack {
            if vm.isLoading {
                ProgressView()
            } else {
                content()
            }
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

    @ViewBuilder
    func content() -> some View {
        VStack {
            if vm.isSelling {
                CurrencySelector(inputField: $vm.sellingCurrencyValue, actionTitle: "Sell",
                                 currencyTitle: vm.selectedCurrency.description,
                                 currencyCode: vm.selectedCurrency.id, onCurrecnyTap: {
                                     showingCurrencyList = true
                                 }, onEditing: { isEditing in
                                     vm.isSellingFieldEditing.send(isEditing)
                                 })
            } else {
                CurrencySelector(inputField: $vm.sellingCurrencyValue, actionTitle: "Sell",
                                 currencyTitle: vm.selectedRate.description,
                                 currencyCode: vm.selectedRate.id, onCurrecnyTap: {
                                     showingRatesList = true
                                 }, onEditing: { isEditing in
                                     vm.isSellingFieldEditing.send(isEditing)
                                 })
            }

            ZStack {
                HStack {
                    Spacer()
                }.frame(height: 0.5)
                    .background(.gray)
                Button(action: {
                    vm.isSelling.toggle()
                }, label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .frame(width: 30, height: 30)
                        .background(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                })
            }

            if vm.isSelling {
                CurrencySelector(inputField: $vm.buyingCurrencyValue, actionTitle: "Buy",
                                 currencyTitle: vm.selectedRate.description,
                                 currencyCode: vm.selectedRate.id, onCurrecnyTap: {
                                     showingRatesList = true
                                 }, onEditing: { isEditing in
                                     vm.isBuyingFieldEditing.send(isEditing)
                                 })
            } else {
                CurrencySelector(inputField: $vm.buyingCurrencyValue, actionTitle: "Buy",
                                 currencyTitle: vm.selectedCurrency.description,
                                 currencyCode: vm.selectedCurrency.id, onCurrecnyTap: {
                                     showingCurrencyList = true
                                 }, onEditing: { isEditing in
                                     vm.isBuyingFieldEditing.send(isEditing)
                                 })
            }

            Toggle(isOn: $vm.useNonCashRate, label: {
                HStack {
                    Spacer()
                    Text("Non cash rate")
                        .foregroundColor(vm.isCashRateAvailable ? Color.primary : .gray)
                        .disabled(!vm.isCashRateAvailable)
                }
            }).disabled(!vm.isCashRateAvailable)
        }
    }
}

struct HomeScene_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyConverterScene(vm: CurrencyConverterVM(diContainer: DIContainerMock.previewMock()))
    }
}
