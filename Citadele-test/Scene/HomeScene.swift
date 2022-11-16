//
//  HomeScene.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 16/11/2022.
//

import SwiftUI

struct HomeScene: View {
    @State var buyAmount: String = "0"
    @State var sellAmount: String = "0"
    @State var isNonCash: Bool = false
    @StateObject var vm = CurrencyConverterVM()

    var body: some View {
        VStack {
            if let sellingCurecny = vm.sellingCurrency {
                CurrencySelector(inputField: $sellAmount,
                                 currencyTitle: sellingCurecny.description,
                                 currencyCode: sellingCurecny.id)
            }

            HStack {
                Spacer()
            }.frame(height: 0.5)
                .background(.gray)

            if let buyingCurecny = vm.buyingCurrency {
                CurrencySelector(inputField: $buyAmount,
                                 currencyTitle: buyingCurecny.description,
                                 currencyCode: buyingCurecny.id)
            }

            Toggle(isOn: $isNonCash, label: {
                HStack {
                    Spacer()
                    Text("Non cash rate")
                }
            })
        }
        .padding(.horizontal)
    }
}

struct HomeScene_Previews: PreviewProvider {
    static var previews: some View {
        HomeScene()
    }
}
