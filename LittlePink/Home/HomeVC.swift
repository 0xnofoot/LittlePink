//
//  HomeVC.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/8.
//

import UIKit
import XLPagerTabStrip

class HomeVC: ButtonBarPagerTabStripViewController {
    override func viewDidLoad() {
        // MARK: 设置上方的bar，按钮，条的UI

        // selectedBar--按钮下方条
        settings.style.selectedBarBackgroundColor = mainColor
        settings.style.selectedBarHeight = 3

        // buttonBarItem--文本或图片的按钮
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = .systemFont(ofSize: 16)
        settings.style.buttonBarItemLeftRightMargin = 0

        super.viewDidLoad()

        containerView.bounces = false

        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, _: CGFloat, changeCurrentIndex: Bool, _: Bool) in
            guard changeCurrentIndex == true else { return }

            oldCell?.label.textColor = .secondaryLabel
            newCell?.label.textColor = .label
        }
    }

    override func viewControllers(for _: PagerTabStripViewController) -> [UIViewController] {
        let followVC = storyboard!.instantiateViewController(identifier: kFollowVCID)
        let nearyByVC = storyboard!.instantiateViewController(identifier: kNearByVCID)
        let discoveryVC = storyboard!.instantiateViewController(identifier: kDiscoveryVCID)

        return [discoveryVC, followVC, nearyByVC]
    }
}
