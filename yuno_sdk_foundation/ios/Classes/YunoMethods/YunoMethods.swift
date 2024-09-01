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
    private let methodChannel: FlutterMethodChannel
    var viewController: UIViewController?
    var countryCode: String = ""
    var checkoutSession: String = ""
    var language: String?

    private lazy var window: UIWindow? = {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }()

    init(methodChannel: FlutterMethodChannel) {
        viewController = UIViewController()
        self.methodChannel = methodChannel
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
        handleOTT(token: token)
        removeViews()
    }
    func yunoPaymentResult(_ result: YunoSDK.Yuno.Result) {
        handleStatus(status: result.rawValue)
        removeViews()
    }
    private func removeViews() {
        guard let window = self.window,
              let controller = self.viewController,
              let rc = window.rootViewController else { return }
        controller.dismiss(animated: true)
        rc.dismiss(animated: true)
    }

    private func initialize(app: AppConfiguration) {
        let appearance = app.configuration?.appearance
        let yunoConfig = app.yunoConfig
        let cardFormType = CardFlow(rawValue: yunoConfig.cardFlow ?? "oneStep")
        Yuno.startCheckout(with: self)
        Yuno.initialize(
            apiKey: app.apiKey,
            config: YunoConfig(
                cardFormType: cardFormType?.toCardFormType ?? .oneStep,
                appearance: Yuno.Appearance(
                    fontFamily: appearance?.fontFamily,
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
                saveCardEnabled: yunoConfig.saveCardEnable ?? false,
                keepLoader: yunoConfig.keepLoader ?? false,
                showUnfoldedCardForm: yunoConfig.cardFormDeployed ?? false,
                isDynamicViewEnabled: yunoConfig.isDynamicViewEnable ?? false
            )
        )
    }
}

extension YunoMethods {
    func handleStatus(status: Int) {
        methodChannel.invokeMethod(Keys.status.rawValue, arguments: status)
    }

    func handleOTT(token: String) {
        methodChannel.invokeMethod(Keys.ott.rawValue, arguments: token)
    }
    func handleHideLoader(call: FlutterMethodCall, result: @escaping FlutterResult) {
            Yuno.hideLoader()
    }
    func continuePayment(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? Bool else {
            return result(YunoError.invalidArguments())
        }
            Yuno.continuePayment(showPaymentStatus: args)
            presentController {
                return result(YunoError.somethingWentWrong())
            }
    }

    func handleStartPaymentLite(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
          return result(YunoError.invalidArguments())
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: args, options: [])
            let decoder = JSONDecoder()
            let startPayment = try decoder
            .decode(StartPayment.self, from: jsonData)
            if startPayment.paymentMetdhodSelected.paymentMethodType.isEmpty ||
               startPayment.checkoutSession.isEmpty || startPayment.countryCode.isEmpty {
                 result(YunoError
                    .customError(
                    code: "6",
                    message: "Missing params",
                    details: "param:\(startPayment.paymentMetdhodSelected.paymentMethodType) is empty"
                )
              )
            }
            self.countryCode = startPayment.countryCode
            self.checkoutSession = startPayment.checkoutSession
            Yuno.startPaymentLite(
                paymentSelected: startPayment.paymentMetdhodSelected,
                showPaymentStatus: startPayment.showPaymentStatus
            )

            presentController {
                return result(YunoError.somethingWentWrong())
            }
        } catch {
            result(YunoError.somethingWentWrong())
        }
    }

    func handleInitialize(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
           return result(YunoError.invalidArguments())
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: args, options: [])
            let decoder = JSONDecoder()
            let app = try decoder.decode(AppConfiguration.self, from: jsonData)

            if app.apiKey.isEmpty {
                 result(YunoError.missingParams())
            }
            self.language = app.yunoConfig.lang
            self.initialize(app: app )
             result(true)
        } catch {
             result(YunoError.somethingWentWrong())
        }
    }
    private func presentController(error: @escaping () -> Void ) {
        guard let window = self.window,
              let controller = self.viewController,
              let rc = window.rootViewController else { return }
        if rc.presentedViewController == nil {
            rc.present(controller, animated: true)
            window.makeKeyAndVisible()
        } else {
            error()
        }
    }
}
