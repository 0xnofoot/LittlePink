//
//  POIVC.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/11.
//

import UIKit

// MARK: - POIVC

class POIVC: UIViewController {
    var delegate: POIVCDelegate?

    var poiName = ""
    var poiLocation = ""

    lazy var locationManager = AMapLocationManager()

    lazy var mapSearch = AMapSearchAPI()

    // 搜索周边POI请求
    lazy var aroundSearchRequest: AMapPOIAroundSearchRequest = {
        let request = AMapPOIAroundSearchRequest()

        request.location = AMapGeoPoint.location(
            withLatitude: CGFloat(latitude),
            longitude: CGFloat(longtitude)
        )
        request.offset = kPOIsOffset
        // request.types = kPOITypes
        return request
    }()

    // 关键字搜索POI请求
    lazy var keywordsSearchRequest: AMapPOIKeywordsSearchRequest = {
        let request = AMapPOIKeywordsSearchRequest()
        request.offset = kPOIsOffset
        // request.types = kPOITypes

        return request
    }()

    lazy var footer = MJRefreshAutoNormalFooter()

    // private var pois = [Array(repeating: "", count: 2)]
    var pois = kPOIsInitArr
    var aroundSearchPOIs = kPOIsInitArr

    var latitude = 0.0
    var longtitude = 0.0
    var keywords = ""
    var currentAroundPage = 1
    var currentKeywordsPage = 1

    @IBOutlet
    var tableView: UITableView!
    @IBOutlet
    var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        requestLocation()
    }
}

// MARK: UITableViewDataSource

extension POIVC: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return pois.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: kPOICellID,
            for: indexPath
        ) as! POICell

        // print("pois.count:\(pois.count)")
        // print("\(indexPath.row)")

        guard !pois.isEmpty else { return cell }
        let poi = pois[indexPath.row]
        cell.poi = poi

        if poi[0] == poiName && poi[1] == poiLocation {
            cell.accessoryType = .checkmark
        }
        return cell
    }
}

// MARK: UITableViewDelegate

extension POIVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = .checkmark

        print(pois)
        delegate?.updatePOIName(pois[indexPath.row][0], pois[indexPath.row][1])

        dismiss(animated: true)
    }
}
