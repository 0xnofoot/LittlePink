//
//  NoteEditVC-Helper.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/13.
//

import Foundation

extension NoteEditVC {
    func isValidateNote() -> Bool {
        guard !photos.isEmpty else {
            showTextHUD("至少需要上传一张图片哦")
            return false
        }

        guard textViewIAView.currentTextCount <= kMaxNoteTextCount else {
            showTextHUD("标题最多输入\(kMAxNoteTitleCount)字哦")
            return false
        }

        return true
    }

    func handleTFEditChanged() {
        guard titleTextField.markedTextRange == nil else { return }
        if titleTextField.unwrappedText.count > kMAxNoteTitleCount {
            titleTextField.text = String(titleTextField.unwrappedText.prefix(kMAxNoteTitleCount))

            showTextHUD("标题最多输入\(kMAxNoteTitleCount)字哦")

            DispatchQueue.main.async {
                let end = self.titleTextField.endOfDocument
                self.titleTextField.selectedTextRange = self.titleTextField.textRange(from: end, to: end)
            }
        }
        titleCountLabel.text = "\(kMAxNoteTitleCount - titleTextField.unwrappedText.count)"
    }
}
