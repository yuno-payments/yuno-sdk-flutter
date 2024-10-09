//
//  ViewArguments.swift
//  Pods
//
//  Created by steven on 1/10/24.
//

import Foundation
import YunoSDK

class ViewArguments: Codable {
    var checkoutSession: String
    var countryCode: String
    var width: CGFloat
    var viewType: PaymentMethodsViewType
    init?(checkoutSession: String,countryCode: String, width: CGFloat, viewType: Int) {
        self.checkoutSession = checkoutSession
        self.countryCode = countryCode
        self.width = width
        self.viewType = PaymentMethodsViewType(rawValue: viewType) ?? .separated
    }
    enum CodingKeys: String, CodingKey {
        case checkoutSession
        case countryCode
        case width
        case viewType
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        checkoutSession = try container.decode(String.self, forKey: .checkoutSession)
        countryCode = try container.decode(String.self, forKey: .countryCode)
        width = try container.decode(CGFloat.self, forKey: .width)
        let viewTypeInt = try container.decode(Int.self, forKey: .viewType)
        viewType = PaymentMethodsViewType(rawValue: viewTypeInt) ?? .separated
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(checkoutSession, forKey: .checkoutSession)
        try container.encode(width, forKey: .width)
        try container.encode(countryCode, forKey: .countryCode)
        try container.encode(viewType.rawValue, forKey: .viewType)
    }
}
