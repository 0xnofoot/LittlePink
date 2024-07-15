//
//  POIVC-Location.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/11.
//

import Foundation

extension POIVC {
    func requestLocation() {
        showLoadHUD()
        locationManager.requestLocation(withReGeocode: true, completionBlock: {
            [weak self] (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in

            if let error = error {
                let error = error as NSError

                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    print("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    self?.hideLoadHUD()
                    return
                } else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue
                {
                    print("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                    self?.hideLoadHUD()
                    return
                }

            } else {
                // no error
            }

            guard let POIVC = self else { return }

            if let location = location {
                POIVC.latitude = location.coordinate.latitude
                POIVC.longtitude = location.coordinate.longitude

                // MARK: 检索周边POI
                POIVC.setAroundSearchFooter()
                POIVC.makeAroundSearch()
            }

            if let reGeocode = reGeocode {
                guard let formattedArrress = reGeocode.formattedAddress, !formattedArrress.isEmpty else { return }
                let province = reGeocode.province == reGeocode.city ? "" : reGeocode.province
                let currentPOI = [reGeocode.poiName ?? kNoPOIPH,
                                  "\(province.unwrappedText)\(reGeocode.city.unwrappedText)\(reGeocode.district.unwrappedText)\(reGeocode.street.unwrappedText)\(reGeocode.number.unwrappedText)"]
                POIVC.pois.append(currentPOI)
                POIVC.aroundSearchPOIs.append(currentPOI)

                DispatchQueue.main.async {
                    POIVC.tableView.reloadData()
                }
            }
        })
    }
}

// MARK: - 一般函数

extension POIVC {
    private func makeAroundSearch(_ page: Int = 1) {
        aroundSearchRequest.page = page
        mapSearch?.aMapPOIAroundSearch(aroundSearchRequest)
    }

    func setAroundSearchFooter() {
        footer.resetNoMoreData()
        footer.setRefreshingTarget(self, refreshingAction: #selector(aroundSearchPullToRefresh))
    }
}

// MAKR: - 监听
extension POIVC {
    @objc private func aroundSearchPullToRefresh() {
        currentAroundPage += 1
        makeAroundSearch(currentAroundPage)
        footer.endRefreshing()
    }
}
