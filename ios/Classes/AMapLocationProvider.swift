//
//  HILocationProvider.swift
//  HIVendorManager
//
//  Created by HaviLee on 2020/2/12.
//

import Foundation
import HIVendorManager
import AMapLocationKit

class AMapLocationProvider: NSObject {
    //定义manager
    private lazy var locationManager: AMapLocationManager = {
        let locationManager = AMapLocationManager()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.locationTimeout = 10
        locationManager.desiredAccuracy = 40
        locationManager.distanceFilter = 100 //最小定位更新距离
        return locationManager
    }()
    
    //用于编码
//    lazy var searchAPI: Amapsea = {
//        <#statements#>
//        return <#value#>
//    }()
    private var _coordinate: CLLocationCoordinate2D?
    private var _addressComponent: AddressComponent?
    private var updateLocationClosures = [UpdateLocationCallback]()
    private var regeoSucsessCloures = [RegeoSuccessCallback]()
    private var geoSuccessClosures = [GeoSuccessCallback]()
    private let semaphore = DispatchSemaphore(value: 1)
}

extension AMapLocationProvider: AMapLocationManagerDelegate {
    
    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        print("❌❌❌❌❌❌定位失败: \(error.debugDescription)")
    }
        
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
        //定位超时处理
        if -location.timestamp.timeIntervalSinceNow > 1.0 {
            self._coordinate = location.coordinate
            if let callback = updateLocationClosures.last {
                callback(location.coordinate)
            }
            return
        }
        _coordinate = location.coordinate
        updateLocationClosures.forEach {$0(location.coordinate)}
        regeoSucsessCloures.forEach { (regeoCallback) in
            let address = AddressComponent.init(regeocode: reGeocode)
            regeoCallback(address)
        }
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didChange status: CLAuthorizationStatus) {
        
    }
}

extension AMapLocationProvider: LocationProvider {
    var coordinate: CLLocationCoordinate2D? {
        return _coordinate
    }
    
    var addressComponent: AddressComponent? {
        return _addressComponent
    }
    
    func updateLocation(callback: LocationProvider.UpdateLocationCallback?) {
        if let completion = callback {
            updateLocationClosures.append(completion)
        }
        locationManager.startUpdatingLocation()
    }
    
    func stopLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func regeoCode(_ coor: CLLocationCoordinate2D, callback: LocationProvider.RegeoSuccessCallback?) {
        semaphore.wait()
        if let callback = callback {
            regeoSucsessCloures.append(callback)
        }
        
    }
    
    func geocode(_ addr: String, callback: LocationProvider.GeoSuccessCallback?) {
        
    }
    
    
}

extension AddressComponent {
    init(regeocode: AMapLocationReGeocode) {
        self.init()
        
        coordinate      = nil
        country         = regeocode.country
        
//                = regeocode.province
        city            = regeocode.city
        cityCode        = regeocode.citycode
        district        = regeocode.district
        adcode          = regeocode.adcode
//        township        = regeocode.township
//        neighborhood    = regeocode.neighborhood
//        building        = regeocode.building
    }
}



