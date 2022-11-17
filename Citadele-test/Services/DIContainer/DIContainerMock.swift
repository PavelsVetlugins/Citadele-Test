//
//  DIContainerMock.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 17/11/2022.
//

import Foundation

class DIContainerMock: DIContainerProtocol {
    var components: [String: Any]

    public init(components: [String: Any] = [:]) {
        self.components = components
    }

    func register<Component>(type: Component.Type, component: Any) {
        components["\(type)"] = component
    }

    func resolve<Component>(type: Component.Type) -> Component? {
        return components["\(type)"] as? Component
    }

    func resolve<Component>() -> Component? {
        return components["\(Component.self)"] as? Component
    }

    static func previewMock() -> DIContainerMock {
        let mockedContainer = DIContainerMock()
        mockedContainer.register(type: AlertManager.self, component: AlertManager())
        mockedContainer.register(type: CurrencyRateServiceProviding.self, component: CurrencyRateServiceMock())

        return mockedContainer
    }
}
