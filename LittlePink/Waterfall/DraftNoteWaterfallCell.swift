//
//  DraftNoteWaterfallCell.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/12.
//

import UIKit

class DraftNoteWaterfallCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet var isVideoImageView: UIImageView!

    var draftNote: DraftNote? {
        didSet {
            guard let draftNote = draftNote else { return }

            imageView.image = UIImage(draftNote.coverPhoto) ?? imagePH

            let title = draftNote.title!
            titleLabel.text = title.isEmpty ? "无题" : title
            dateLabel.text = draftNote.updateAt?.formattedDate
            isVideoImageView.isHidden = !draftNote.isVideo

        }
    }
}
