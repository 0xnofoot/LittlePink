//
//  FollowVC.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/8.
//

import UIKit
import XLPagerTabStrip

class FollowVC: UIViewController, IndicatorInfoProvider {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func indicatorInfo(for _: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: NSLocalizedString("Follow", comment: "首页上方的关注标签"))
    }
}
