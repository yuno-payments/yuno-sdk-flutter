//
//  YunoEnrollmentMethods.swift
//  Pods
//
//  Created by steven on 21/10/24.
//
import YunoSDK
import Flutter

extension YunoMethods: YunoEnrollmentDelegate {
    func yunoEnrollmentResult(_ result: YunoSDK.Yuno.Result) {
        methodChannel.invokeMethod(Keys.enrollmentStatus.rawValue, arguments: result.rawValue)
    }
    func startEnrollment(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result(YunoError.invalidArguments())
            return
        }
        do {
            let decoder = JSONDecoder()
            let startEnrollment = try decoder.decode(StartEnrollmentPayment.self, from: args)
            if startEnrollment.countryCode.isEmpty ||
                startEnrollment.customerSession.isEmpty {
                result(YunoError
                    .customError(
                        code: "6",
                        message: "Missing params",
                        details: "param: Some arguments is empty or invalid"
                    )
                )
            }
            self.customerSession = startEnrollment.customerSession
            self.countryCode = startEnrollment.countryCode
            Yuno.enrollPayment(with: self, showPaymentStatus: startEnrollment.showPaymentStatus)
        } catch {
        }
    }
}

class YunoEnrollmentMethods: YunoEnrollmentDelegate {
    var customerSession: String = ""
    var countryCode: String = ""
    var language: String?
    let methodChannel: FlutterMethodChannel
    private lazy var window: UIWindow? = {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }()
    init(methodChannel: FlutterMethodChannel) {
        self.methodChannel = methodChannel
    }
    var viewController: UIViewController? {
        window?.rootViewController
    }
    func yunoEnrollmentResult(_ result: YunoSDK.Yuno.Result) {
        methodChannel.invokeMethod(Keys.enrollmentStatus.rawValue, arguments: result.rawValue)
    }
    func startEnrollment(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result(YunoError.invalidArguments())
            return
        }
        do {
            let decoder = JSONDecoder()
            let startEnrollment = try decoder.decode(StartEnrollmentPayment.self, from: args)
            if startEnrollment.countryCode.isEmpty ||
                startEnrollment.customerSession.isEmpty {
                result(YunoError
                    .customError(
                        code: "6",
                        message: "Missing params",
                        details: "param: Some arguments is empty or invalid"
                    )
                )
            }
            self.customerSession = startEnrollment.customerSession
            self.countryCode = startEnrollment.countryCode
            Yuno.enrollPayment(with: self, showPaymentStatus: startEnrollment.showPaymentStatus)
        } catch {
            result(YunoError.somethingWentWrong())
        }
    }
}
