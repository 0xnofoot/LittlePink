//
//  WaterfallVC-Delegate.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/12.
//

import Foundation

extension WaterfallVC {
    override func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isMyDraft {
            let draftNote = draftNotes[indexPath.item]
            if let photosData = draftNote.photos,
               let photosDataArr = try? JSONDecoder().decode([Data].self, from: photosData)
            {
                let photos = photosDataArr.map { UIImage($0) ?? imagePH }
                // draftNote.video
                let videoURL = FileManager.default.save(draftNote.video, to: "video", as: "\(UUID().uuidString).mp4")

                let vc = storyboard!.instantiateViewController(identifier: kNoteEditVCID) as! NoteEditVC
                vc.draftNote = draftNote
                vc.photos = photos
                vc.videoURL = videoURL
                vc.updateDraftNoteFinished = {
                    self.getDraftNotes()
                }

                navigationController?.pushViewController(vc, animated: true)

            } else {
                showTextHUD("加载草稿失败")
            }

        } else {}
    }
}
