//
//  CardFlow.swift
//  yuno_sdk_foundation
//
//  Created by steven on 21/08/24.
//

import Foundation
import YunoSDK

enum CardFlow: String {
    case oneStep
    case multiStep
}

extension CardFlow {
    var toCardFormType: CardFormType? {
        switch self {
            case .oneStep:
                return .oneStep
            case .multiStep:
                return .multiStep
        }
    }
}
