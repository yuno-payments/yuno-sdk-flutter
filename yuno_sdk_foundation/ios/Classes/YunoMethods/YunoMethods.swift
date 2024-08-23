//
    //  YunoMethods.swift
    //  Pods
    //
    //  Created by steven on 10/08/24.
    //

import Flutter
import Foundation
import YunoSDK

class YunoMethods: YunoPaymentDelegate, YunoMethodsViewDelegate {
    var viewController: UIViewController?
    var countryCode: String = ""
    var checkoutSession: String = ""
    private lazy var window: UIWindow? = {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }()
    init() {
        viewController = UIViewController()
    }

    func yunoPaymentResult(_ result: YunoSDK.Yuno.Result) {
        print(result)
       guard let window = self.window else {return }
       guard let vc = self.viewController else { return}
       guard let rc = window.rootViewController else { return}
       vc.dismiss(animated: true)
       rc.dismiss(animated: true)

    }

    func yunoDidSelect(paymentMethod: any YunoSDK.PaymentMethodSelected) {

    }

    func yunoDidSelect(enrollmentMethod: any YunoSDK.EnrollmentMethodSelected) {

    }

    func yunoUpdatePaymentMethodsViewHeight(_ height: CGFloat) {

    }

    func yunoUpdateEnrollmentMethodsViewHeight(_ height: CGFloat) {

    }

    func yunoCreatePayment(with token: String) {
        guard let window = self.window else {return }
        guard let vc = self.viewController else { return}
        guard let rc = window.rootViewController else { return}
        vc.dismiss(animated: true)
        rc.dismiss(animated: true)
        print(token)
    }

    private func initialize(app: AppConfiguration) {
        let appearance = app.configuration?.appearance
        let configuration = app.configuration
        let cardFormType = CardFlow(rawValue: configuration?.cardFlow ?? "oneStep")
        Yuno.initialize(
            apiKey: app.apiKey,
            config: YunoConfig(
                cardFormType: cardFormType?.toCardFormType ?? .oneStep,
                appearance: Yuno.Appearance(
                    accentColor: appearance?.accentColor,
                    buttonBackgroundColor: appearance?.buttonBackgroundColor,
                    buttonTitleColor: appearance?.buttonTitleBackgroundColor,
                    buttonBorderColor: appearance?.buttonBorderBackgroundColor,
                    secondaryButtonBackgroundColor: appearance?.secondaryButtonBackgroundColor,
                    secondaryButtonTitleColor: appearance?.secondaryButtonTitleBackgroundColor,
                    secondaryButtonBorderColor: appearance?.secondaryButtonBorderBackgroundColor,
                    disableButtonBackgroundColor: appearance?.disableButtonBackgroundColor,
                    disableButtonTitleColor: appearance?.disableButtonTitleBackgroundColor,
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
    func handleStartPaymentLite(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let window = self.window else {return }
        guard let controller = self.viewController else { return }
        guard let rc = window.rootViewController else {return}
        guard let args = call.arguments as? [String: Any] else {
            return  result(YunoError.invalidArguments())
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: args, options: [])
            let decoder = JSONDecoder()
            let startPayment = try decoder
            .decode(StartPayment.self, from: jsonData)
            if startPayment.paymentMetdhodSelected.paymentMethodType.isEmpty ||
               startPayment.checkoutSession.isEmpty {
                return result(YunoError
                    .customError(
                    code: "6",
                    message: "Missing params",
                    details: "param:\(startPayment.paymentMetdhodSelected.paymentMethodType) is empty"
                )
              )
            }
            self.checkoutSession = startPayment.checkoutSession
            Yuno.startPaymentLite(
                paymentSelected: startPayment.paymentMetdhodSelected,
                showPaymentStatus: startPayment.showPaymentStatus
            )

            if rc.presentedViewController == nil {
                rc.present(controller, animated: true)
                window.makeKeyAndVisible()
            } else {
                return result(YunoError.somethingWentWrong())
            }

        } catch {
            return result(YunoError.somethingWentWrong())
        }
    }

    func handleInitialize(call: FlutterMethodCall, result: @escaping FlutterResult) {

        guard let args = call.arguments as? [String: Any] else {
            return  result(YunoError.invalidArguments())
        }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: args, options: [])
            let decoder = JSONDecoder()
            let app = try decoder.decode(AppConfiguration.self, from: jsonData)

            if app.apiKey.isEmpty  || app.countryCode.isEmpty {
                return result(YunoError.missingParams())
            }
            self.countryCode = app.countryCode
            self.initialize(app: app )
            return result(true)
        } catch {
            return result(YunoError.somethingWentWrong())
        }
    }
}
