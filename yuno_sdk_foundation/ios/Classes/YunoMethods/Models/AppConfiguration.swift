//
//  YunoConfigurationModel.swift
//  Pods
//
//  Created by steven on 10/08/24.
//

import Foundation
import YunoSDK
import UIKit

// Card Flow enum
enum CardFlow: String {
    case oneStep = "oneStep"
    case multiStep = "multiStep"
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



struct Appearance: Codable, Sendable {
    let accentColor: UIColor?
    let buttonBackgroundColor: UIColor?
    let buttonTitleBackgroundColor: UIColor?
    let buttonBorderBackgroundColor: UIColor?
    let secondaryButtonBackgroundColor: UIColor?
    let secondaryButtonTitleBackgroundColor: UIColor?
    let secondaryButtonBorderBackgroundColor: UIColor?
    let disableButtonBackgroundColor: UIColor?
    let disableButtonTitleBackgroundColor: UIColor?
    let checkboxColor: UIColor?

    enum CodingKeys: String, CodingKey {
        case accentColor
        case buttonBackgroundColor = "buttonBackgrounColor"
        case buttonTitleBackgroundColor = "buttonTitleBackgrounColor"
        case buttonBorderBackgroundColor = "buttonBorderBackgrounColor"
        case secondaryButtonBackgroundColor = "secondaryButtonBackgrounColor"
        case secondaryButtonTitleBackgroundColor = "secondaryButtonTitleBackgrounColor"
        case secondaryButtonBorderBackgroundColor = "secondaryButtonBorderBackgrounColor"
        case disableButtonBackgroundColor = "disableButtonBackgrounColor"
        case disableButtonTitleBackgroundColor = "disableButtonTitleBackgrounColor"
        case checkboxColor
    }

    // Custom initializer to decode from a map
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accentColor = UIColor(hex: try container.decodeIfPresent(Int.self, forKey: .accentColor))
        buttonBackgroundColor = UIColor(hex: try container.decodeIfPresent(Int.self, forKey: .buttonBackgroundColor))
        buttonTitleBackgroundColor = UIColor(hex: try container.decodeIfPresent(Int.self, forKey: .buttonTitleBackgroundColor))
        buttonBorderBackgroundColor = UIColor(hex: try container.decodeIfPresent(Int.self, forKey: .buttonBorderBackgroundColor))
        secondaryButtonBackgroundColor = UIColor(hex: try container.decodeIfPresent(Int.self, forKey: .secondaryButtonBackgroundColor))
        secondaryButtonTitleBackgroundColor = UIColor(hex: try container.decodeIfPresent(Int.self, forKey: .secondaryButtonTitleBackgroundColor))
        secondaryButtonBorderBackgroundColor = UIColor(hex: try container.decodeIfPresent(Int.self, forKey: .secondaryButtonBorderBackgroundColor))
        disableButtonBackgroundColor = UIColor(hex: try container.decodeIfPresent(Int.self, forKey: .disableButtonBackgroundColor))
        disableButtonTitleBackgroundColor = UIColor(hex: try container.decodeIfPresent(Int.self, forKey: .disableButtonTitleBackgroundColor))
        checkboxColor = UIColor(hex: try container.decodeIfPresent(Int.self, forKey: .checkboxColor))
    }

    // Custom encode function
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accentColor?.toHex(), forKey: .accentColor)
        try container.encode(buttonBackgroundColor?.toHex(), forKey: .buttonBackgroundColor)
        try container.encode(buttonTitleBackgroundColor?.toHex(), forKey: .buttonTitleBackgroundColor)
        try container.encode(buttonBorderBackgroundColor?.toHex(), forKey: .buttonBorderBackgroundColor)
        try container.encode(secondaryButtonBackgroundColor?.toHex(), forKey: .secondaryButtonBackgroundColor)
        try container.encode(secondaryButtonTitleBackgroundColor?.toHex(), forKey: .secondaryButtonTitleBackgroundColor)
        try container.encode(secondaryButtonBorderBackgroundColor?.toHex(), forKey: .secondaryButtonBorderBackgroundColor)
        try container.encode(disableButtonBackgroundColor?.toHex(), forKey: .disableButtonBackgroundColor)
        try container.encode(disableButtonTitleBackgroundColor?.toHex(), forKey: .disableButtonTitleBackgroundColor)
        try container.encode(checkboxColor?.toHex(), forKey: .checkboxColor)
    }
}


struct Configuration: Codable, Sendable {
    let appearance: Appearance?
    let cardflow:String?
    let saveCardEnable: Bool?
    let keepLoader: Bool?
    let isDynamicViewEnable: Bool?

        
        
    init(appearance: Appearance?, 
         cardflow: String?, 
         saveCardEnable: Bool?,
         keepLoader: Bool?,
         isDynamicViewEnable: Bool?
    ) {
        self.appearance = appearance
        self.cardflow = cardflow
        self.saveCardEnable = saveCardEnable
        self.keepLoader = keepLoader
        self.isDynamicViewEnable = isDynamicViewEnable
 
    }
}

struct AppConfiguration:Codable,Sendable{
    let apiKey:String
    let countryCode:String
    let configuration:Configuration?
    
    init(apiKey: String, countryCode: String, configuration: Configuration?) {
        self.apiKey = apiKey
        self.countryCode = countryCode
        self.configuration = configuration
    }

}


extension UIColor {
    // Initialize UIColor from hex integer
    convenience init?(hex: Int?) {
        guard let hex = hex else { return nil }
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        let alpha = CGFloat((hex >> 24) & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    // Convert UIColor to hex integer
    func toHex() -> Int? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let r = Int(red * 255.0)
        let g = Int(green * 255.0)
        let b = Int(blue * 255.0)
        let a = Int(alpha * 255.0)
        return (a << 24) + (r << 16) + (g << 8) + b
    }
}
