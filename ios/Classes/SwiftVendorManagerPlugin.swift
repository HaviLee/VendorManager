import Flutter
import UIKit
import HIVendorManager
import AMapFoundationKit
import CoreLocation

enum ChannelMethod: String {
    case GetLocation = "getLocation"
    case HasPermission = "hasPermission"
    case GetPlatformVersion = "getPlatformVersion"
    case RequestPermission = "requestPermission"
}

public class SwiftVendorManagerPlugin: NSObject, FlutterPlugin {
    
    private var locationManager: CLLocationManager?
    private var locationManagerProvider: LocationProvider?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        AMapServices.shared()?.apiKey = "4a4363bb72fc4d70773251c4115ed45b"
        LocationManager.registerLocationProvider(AMapLocationProvider())
        let channel = FlutterMethodChannel(name: "hi_vendor_manager", binaryMessenger: registrar.messenger())
        let instance = SwiftVendorManagerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public override init() {
        locationManager = CLLocationManager.init()
        super.init()
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == ChannelMethod.GetLocation.rawValue {
//            let coor = [
//                "latitude" : 13.333,
//                "longitude" : 344.33
//            ]
//            result("nativd")
            self.getCurrentLocation(result: result)
        } else if call.method == ChannelMethod.HasPermission.rawValue {
            if LocationManager.isSupportLocation {
                result(1)
            } else {
                result(2)
            }
        } else if call.method == ChannelMethod.GetPlatformVersion.rawValue {
            result("platform" + UIDevice.current.systemVersion)
        } else if call.method == ChannelMethod.RequestPermission.rawValue {
            if LocationManager.isSupportLocation {
                result(1)
            } else {
                requreLocationPermission()
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}

extension SwiftVendorManagerPlugin {
    
    /*
     进行授权请求
     */
    func requreLocationPermission() {
        if Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") != nil {
            locationManager?.requestWhenInUseAuthorization()
        } else if Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil {
            locationManager?.requestAlwaysAuthorization()
        } else {
            let error: NSError = NSError.init()
            NSException.raise(NSExceptionName.internalInconsistencyException, format: "To use location in iOS8 and above you need to define either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription in the app bundle's Info.plist file", arguments: getVaList([error]))
        }
    }
    
    func getCurrentLocation(result: @escaping FlutterResult) {
        LocationManager.updateLocation { (coordinate: CLLocationCoordinate2D) in
            let coor = [
                "latitude" : coordinate.latitude,
                "longitude" : coordinate.longitude
            ]
            result(coor)
        }
    }
}
