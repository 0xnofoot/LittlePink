//
//  POICell.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/11.
//

import UIKit

class POICell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    var poi = ["", ""] {
        didSet {
           nameLabel.text = poi[0]
           addressLabel.text = poi[1]
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
