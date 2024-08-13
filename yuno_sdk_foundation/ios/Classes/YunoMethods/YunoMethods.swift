//
//  YunoMethods.swift
//  Pods
//
//  Created by steven on 10/08/24.
//

import Flutter
import Foundation
import YunoSDK

class YunoMethods:  YunoPaymentDelegate, YunoMethodsViewDelegate {
    
    var countryCode: String = ""
    var checkoutSession: String = ""
   
   
    func yunoPaymentResult(_ result: YunoSDK.Yuno.Result) {
       
        
    }
    
    func yunoDidSelect(paymentMethod: any YunoSDK.PaymentMethodSelected) {
        
    }
    
    func yunoDidSelect(enrollmentMethod: any YunoSDK.EnrollmentMethodSelected) {
        
    }
    
    func yunoUpdatePaymentMethodsViewHeight(_ height: CGFloat) {
        
    }
    
    func yunoUpdateEnrollmentMethodsViewHeight(_ height: CGFloat) {
        
    }
    
    
    private func initialize(app:AppConfiguration){
        let appearance = app.configuration?.appearance;
        let configuration = app.configuration;
        let cardFormType = CardFlow(rawValue: configuration?.cardflow ?? "oneStep")
        Yuno.initialize(
            apiKey: app.apiKey,
            config: YunoConfig(
                cardFormType:cardFormType?.toCardFormType ?? .oneStep,
                appearance: Yuno.Appearance(
                accentColor: appearance?.accentColor,
                buttonBackgroundColor:  appearance?.buttonBackgroundColor,
                buttonTitleColor: appearance?.buttonTitleBackgroundColor,
                buttonBorderColor:  appearance?.buttonBorderBackgroundColor,
                secondaryButtonBackgroundColor: appearance?.secondaryButtonBackgroundColor,
                secondaryButtonTitleColor: appearance?.secondaryButtonTitleBackgroundColor,
                secondaryButtonBorderColor: appearance?.secondaryButtonBorderBackgroundColor,
                disableButtonBackgroundColor:appearance?.disableButtonBackgroundColor,
                disableButtonTitleColor:appearance?.disableButtonTitleBackgroundColor,
                checkboxColor: appearance?.checkboxColor),
            saveCardEnabled: configuration?.saveCardEnable ?? false,
            keepLoader: configuration?.keepLoader ?? false,
            isDynamicViewEnabled: configuration?.isDynamicViewEnable ?? false
            )
        
        )
        Yuno.startCheckout(with: self)
    }
    
}


extension YunoMethods {
    
     func handleInitialize(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        guard let args = call.arguments as? [String:Any] else{
            return  result(FlutterError(code: "4", message: "Invalid arguments", details: "Arguments are invalid"))
        }
        
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: args, options: [])
            let decoder = JSONDecoder()
            let app = try decoder.decode(AppConfiguration.self, from: jsonData)
            
            if app.apiKey.isEmpty || app.countryCode.isEmpty {
                return result(FlutterError(code: "3", message: "Missing API Key or Country Code", details: "Missing params"))
            }
            
            self.initialize(app: app )
     
            return result(true)
            
        }catch{
         return   result(FlutterError(code: "0", message: "Unexpected Exception", details: "Something went wrong"))
        }
     
    }
}
