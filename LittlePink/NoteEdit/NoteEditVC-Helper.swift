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
            showTextHUD("标题最多输入\(kMaxNoteTitleCount)字哦")
            return false
        }

        return true
    }

    func handleTFEditChanged() {
        guard titleTextField.markedTextRange == nil else { return }
        if titleTextField.unwrappedText.count > kMaxNoteTitleCount {
            titleTextField.text = String(titleTextField.unwrappedText.prefix(kMaxNoteTitleCount))

            showTextHUD("标题最多输入\(kMaxNoteTitleCount)字哦")

            DispatchQueue.main.async {
                let end = self.titleTextField.endOfDocument
                self.titleTextField.selectedTextRange = self.titleTextField.textRange(
                    from: end,
                    to: end
                )
            }
        }
        titleCountLabel.text = "\(kMaxNoteTitleCount - titleTextField.unwrappedText.count)"
    }
}
