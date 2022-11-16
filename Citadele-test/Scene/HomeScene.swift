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

    var body: some View {
        VStack {
            CurrencySelector(inputField: $sellAmount,
                             currencyTitle: "Euro",
                             currencyCode: "EUR")

            HStack {
                Spacer()
            }.frame(height: 0.5)
                .background(.gray)

            CurrencySelector(inputField: $buyAmount,
                             currencyTitle: "US Dollar",
                             currencyCode: "USD")

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
