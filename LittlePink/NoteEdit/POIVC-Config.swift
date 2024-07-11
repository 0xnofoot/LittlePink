//
//  POIVC-Config.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/11.
//

import Foundation

extension POIVC {
    func config() {
        // MARK: 定位
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.locationTimeout = 5
        locationManager.reGeocodeTimeout = 5

        // 搜索POI
        mapSearch?.delegate = self
        
        // 配置 refresh 控件
        tableView.mj_footer = footer

        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        }
    }
}

extension POIVC: AMapLocationManagerDelegate {
    func amapLocationManager(_: AMapLocationManager!, doRequireLocationAuth locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
    }

    func amapLocationManager(_: AMapLocationManager!, doRequireTemporaryFullAccuracyAuth _: CLLocationManager!, completion _: ((Error?) -> Void)!) {}
}
