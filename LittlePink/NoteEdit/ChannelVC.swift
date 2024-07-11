//
//  ChannelVC.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/11.
//

import UIKit
import XLPagerTabStrip

class ChannelVC: ButtonBarPagerTabStripViewController {

    var pvDelegate: ChannelVCDelegate?

    override func viewDidLoad() {
        settings.style.selectedBarHeight = 2
        settings.style.selectedBarBackgroundColor = mainColor
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = .systemFont(ofSize: 15)

        super.viewDidLoad()

        containerView.bounces = false
        changeCurrentIndexProgressive = {
            (oldCell: ButtonBarViewCell?,
             newCell: ButtonBarViewCell?,
             _: CGFloat,
             changeCurrentIndex: Bool,
             _: Bool) in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .secondaryLabel
            newCell?.label.textColor = .label
        }
    }

    override func viewControllers(for _: PagerTabStripViewController) -> [UIViewController] {
        var vcs: [UIViewController] = []
        for i in kChannels.indices {
            let vc = storyboard!.instantiateViewController(identifier: kChannelTableVCID) as! ChannelTableVC
            vc.channel = kChannels[i]
            vc.subChannels = kAllSubChannels[i]
            vcs.append(vc)
        }
        return vcs
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
