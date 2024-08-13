//
//  YunoMethods.swift
//  Pods
//
//  Created by steven on 10/08/24.
//

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
    
    
    func initialize(app:AppConfiguration){
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
