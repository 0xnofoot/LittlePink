//
//  NoteEditVC-Config.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/10.
//

import Foundation

extension NoteEditVC {
    func config() {
        // photoCollectionView.dragInteractionEnabled = true //开启拖放交互，新版已经默认为true
        hideKeyboardWhenTappedAround()
        titleCountLabel.text = "\(kMAxNoteTitleCount)"

        let lineFragmentPadding = textView.textContainer.lineFragmentPadding
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -lineFragmentPadding, bottom: 0, right: -lineFragmentPadding)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let typingAttributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.secondaryLabel,
        ]
        textView.typingAttributes = typingAttributes

        // textView.tintColorDidChange() // 激活修改的 tintcolor ，新版本不需要调用

        textView.inputAccessoryView = Bundle.loadView(fromNib: "TextViewIAView", with: TextViewIAView.self)
        textViewIAView.doneBtn.addTarget(self, action: #selector(resignTextView), for: .touchUpInside)
        textViewIAView.maxTextCountLabel.text = "/\(kMaxNoteTextCount)"

        // MARK: 请求定位权限
        locationManager.requestWhenInUseAuthorization()
        AMapLocationManager.updatePrivacyShow(AMapPrivacyShowStatus.didShow, privacyInfo: AMapPrivacyInfoStatus.didContain)
        AMapLocationManager.updatePrivacyAgree(AMapPrivacyAgreeStatus.didAgree)
    }
}

extension NoteEditVC {
    @objc private func resignTextView() {
        textView.resignFirstResponder()
    }
}
