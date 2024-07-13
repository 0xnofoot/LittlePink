//
//  NoteEditVC-UI.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/13.
//

import Foundation

extension NoteEditVC {
    func setUI() {
        setDraftNoteEditUI()
    }
}

// MARK: 编辑草稿笔记时

extension NoteEditVC {
    private func setDraftNoteEditUI() {
        if let draftNote = draftNote {
            titleTextField.text = draftNote.title
            textView.text = draftNote.text
            channel = draftNote.channel!
            subChannel = draftNote.subChannel!
            poiName = draftNote.poiName!

            if !subChannel.isEmpty {
                updateChannelUI()
            }

            if !poiName.isEmpty {
                updatePOINameUI()
            }
        }
    }

    func updateChannelUI() {
        channelLabel.text = subChannel
        channelIcon.tintColor = blueColor
        channelLabel.textColor = blueColor
        channelPlaceholderLabel.isHidden = true
    }

    func updatePOINameUI() {
        if poiName == "" {
            poiNameIcon.tintColor = .label
            poiNameLabel.text = "添加地点"
            poiNameLabel.textColor = .label
        } else {
            poiNameIcon.tintColor = blueColor
            poiNameLabel.text = poiName
            poiNameLabel.textColor = blueColor
        }
    }
}
