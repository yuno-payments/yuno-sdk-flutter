//
//  StartPayment.swift
//  Pods
//
//  Created by steven on 4/10/24.
//

class StartPayment: Codable {
    var showPaymentStatus: Bool
    init(
        showPaymentStatus: Bool
    ) {
        self.showPaymentStatus = showPaymentStatus
    }
}
