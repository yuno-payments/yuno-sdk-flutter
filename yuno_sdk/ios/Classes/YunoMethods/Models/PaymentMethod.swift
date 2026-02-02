//
//  PaymentMethod.swift
//  yuno_sdk_foundation
//
//  Created by steven on 20/08/24.
//

import Foundation
import YunoSDK

class PaymentMethod: PaymentMethodSelected, Codable {
    var vaultedToken: String?
    var paymentMethodType: String

    init(vaultedToken: String?, paymentMethodType: String) {
        self.vaultedToken = vaultedToken
        self.paymentMethodType = paymentMethodType
    }
}
