import Flutter
import UIKit
import YunoSDK


public class YunoSdkFoundationPlugin: NSObject, FlutterPlugin {
    fileprivate let instance: YunoMethods = YunoMethods()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "yuno/payments", binaryMessenger: registrar.messenger())
    let instanceSDK = YunoSdkFoundationPlugin()
    registrar.addMethodCallDelegate(instanceSDK, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            result(FlutterError(code: "UNAVAILABLE", message: "UIWindow is not available", details: nil))
            return
        }
    switch call.method {
    case "initialize":

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
            
            instance.initialize(app: app )
     
            return result(true)
            
        }catch{
         return   result(FlutterError(code: "0", message: "Unexpected Exception", details: "Something went wrong"))
        }
     

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}


