//
//  StartPayment.swift
//  Pods
//
//  Created by steven on 4/10/24.
//

class StartPayment: Codable {
    var countryCode: String?
    var checkoutSession: String
    var showPaymentStatus: Bool
    init(
        countryCode: String?,
        showPaymentStatus: Bool,
        checkoutSession: String
    ) {
        self.countryCode = countryCode
        self.showPaymentStatus = showPaymentStatus
        self.checkoutSession = checkoutSession
    }
}
