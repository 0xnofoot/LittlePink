//
//  POIVC-KeywordSearch.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/11.
//

extension POIVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_: UISearchBar) {
        dismiss(animated: true)
    }

    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            pois = aroundSearchPOIs
            // hideLoadHUD()
            setAroundSearchFooter()
            tableView.reloadData()
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isBlank else { return }
        keywords = searchText
        pois.removeAll()
        currentKeywordsPage = 1
        setKeywordsSearchFooter()
        showLoadHUD()
        makeKeywordSearch(keywords)
    }
}

// MARK: - 所有搜索POI的回调
extension POIVC: AMapSearchDelegate {
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        hideLoadHUD()

        // print(response.count)
        // print(response.pois.count)

        if response.count == 0 {
            footer.endRefreshingWithNoMoreData()
            return
        }

        for poi in response.pois {
            let province = poi.province == poi.city ? "" : poi.province
            let address = poi.district == poi.address ? "" : poi.address
            let poi = [
                poi.name ?? kNoPoiPH,
                "\(province.unwrappedText)\(poi.city.unwrappedText)\(poi.district.unwrappedText)\(address.unwrappedText)",
            ]
            pois.append(poi)
            if request is AMapPOIAroundSearchRequest {
                aroundSearchPOIs.append(poi)
            }
        }
        tableView.reloadData()
    }
}

// MARK: - 一般函数
extension POIVC {
    private func makeKeywordSearch(_ keywords: String, _ page: Int = 1) {
        keywordsSearchRequest.keywords = keywords
        keywordsSearchRequest.page = page
        mapSearch?.aMapPOIKeywordsSearch(keywordsSearchRequest)
    }

    func setKeywordsSearchFooter() {
        footer.resetNoMoreData()
        footer.setRefreshingTarget(self, refreshingAction: #selector(keywordsSearchPullToRefresh))
    }
}

// MAKR: - 监听
extension POIVC {
    @objc private func keywordsSearchPullToRefresh() {
        currentKeywordsPage += 1
        makeKeywordSearch(keywords, currentKeywordsPage)
        footer.endRefreshing()
    }
}
