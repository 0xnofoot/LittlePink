//
//  TextViewIAView.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/10.
//

import UIKit

class TextViewIAView: UIView {

    @IBOutlet weak var textCountLabel: UILabel!
    @IBOutlet weak var maxTextCountLabel: UILabel!
    @IBOutlet weak var textCountStackView: UIStackView!
    @IBOutlet weak var doneBtn: UIButton!

    var currentTextCount = 0 {
        didSet {
            if currentTextCount <= kMaxNoteTextCount {
                doneBtn.isHidden = false
                textCountStackView.isHidden = true
            }else {
                doneBtn.isHidden = true
                textCountStackView.isHidden = false
                textCountLabel.text = "\(currentTextCount)"
            }
        }
    }

}
