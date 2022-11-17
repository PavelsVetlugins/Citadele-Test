//
//  DIContainer.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 17/11/2022.
//

import Foundation

protocol DIContainerProtocol {
    func register<Component>(type: Component.Type, component: Any)
    func resolve<Component>(type: Component.Type) -> Component?
    func resolve<Component>() -> Component?
}

final class DIContainer: DIContainerProtocol {
    static let shared = DIContainer()

    private init() {}

    var components: [String: Any] = [:]

    func register<Component>(type: Component.Type, component: Any) {
        components["\(type)"] = component
    }

    func resolve<Component>(type: Component.Type) -> Component? {
        return components["\(type)"] as? Component
    }

    func resolve<Component>() -> Component? {
        return components["\(Component.self)"] as? Component
    }
}
