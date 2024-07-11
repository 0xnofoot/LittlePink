//
//  ChannelTableVC.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/11.
//

import UIKit
import XLPagerTabStrip

class ChannelTableVC: UITableViewController {
    var channel = ""
    var subChannels: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return subChannels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kSubChannelCellID, for: indexPath)
        cell.textLabel?.text = "# \(subChannels[indexPath.row])"
        cell.textLabel?.font = .systemFont(ofSize: 15)
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channelVC = parent as! ChannelVC
        channelVC.pvDelegate?.updateChannel(channel: channel, subChannel: subChannels[indexPath.row])
        dismiss(animated: true)
    }
}

extension ChannelTableVC: IndicatorInfoProvider {
    func indicatorInfo(for _: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: channel)
    }
}
