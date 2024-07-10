//
//  DiscoveryVC.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/8.
//

import UIKit
import XLPagerTabStrip

class DiscoveryVC: ButtonBarPagerTabStripViewController, IndicatorInfoProvider {
    override func viewDidLoad() {
        settings.style.selectedBarHeight = 0
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = .systemFont(ofSize: 14)

        super.viewDidLoad()

        containerView.bounces = false

        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, _: CGFloat, changeCurrentIndex: Bool, _: Bool) in
            guard changeCurrentIndex == true else { return }

            oldCell?.label.textColor = .secondaryLabel
            newCell?.label.textColor = .label
        }
    }

    override func viewControllers(for _: PagerTabStripViewController) -> [UIViewController] {
        var vcs: [UIViewController] = []
        for channel in kChannels {
            let vc = storyboard!.instantiateViewController(identifier: kWaterfallVCID) as! WaterfallVC
            vc.channel = channel
            vcs.append(vc)
        }

        return vcs
    }

    func indicatorInfo(for _: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: NSLocalizedString("Discovery", comment: "首页上方的发现标签"))
    }
}
