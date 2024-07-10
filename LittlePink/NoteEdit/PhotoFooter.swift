//
//  PhotoFooter.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/10.
//

import UIKit

class PhotoFooter: UICollectionReusableView {
    @IBOutlet var addPhotoBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        addPhotoBtn.layer.borderWidth = 1
        addPhotoBtn.layer.borderColor = UIColor.quaternaryLabel.cgColor
    }
}
