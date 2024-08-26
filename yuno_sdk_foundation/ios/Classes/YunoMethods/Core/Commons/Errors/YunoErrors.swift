//
//  YunoErrors.swift
//  yuno_sdk_foundation
//
//  Created by steven on 20/08/24.
//

import Foundation
import Flutter

class YunoError {
   static func customError(
    code: String,
    message: String,
    details: String) -> FlutterError {
        return FlutterError(
            code: code,
            message: message,
            details: details
        )
    }

   static func somethingWentWrong() -> FlutterError {
        return FlutterError(
            code: "0",
            message: "Unexpected Exception",
            details: "Something went wrong"
        )
    }
    static func paymentMethodIsRequired() -> FlutterError {
        return FlutterError(
            code: "0",
            message: "Unexpected Exception",
            details: "Something went wrong"
        )
    }
    static func invalidArguments() -> FlutterError {
        return FlutterError(
            code: "4",
            message: "Invalid arguments",
            details: "Arguments are invalid"
        )
    }

    static func missingParams() -> FlutterError {
        return FlutterError(
            code: "3",
            message: "Missing API Key or Country Code",
            details: "Missing params"
        )
    }
}
