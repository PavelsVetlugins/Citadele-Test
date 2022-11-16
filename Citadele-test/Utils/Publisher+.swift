//
//  Combine+.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 16/11/2022.
//

import Combine
import Foundation

extension Publisher {
    func withLatestFrom<P>(_ other: P) -> AnyPublisher<(Self.Output, P.Output), Failure> where P: Publisher, Self.Failure == P.Failure {
        let other = other
            .map { (value: $0, ()) }
            .prepend((value: nil, ()))

        return map { (value: $0, token: UUID()) }
            .combineLatest(other)
            .removeDuplicates(by: { old, new in
                let lhs = old.0, rhs = new.0
                return lhs.token == rhs.token
            })
            .map { ($0.value, $1.value) }
            .compactMap { left, right in
                right.map { (left, $0) }
            }
            .eraseToAnyPublisher()
    }
}
