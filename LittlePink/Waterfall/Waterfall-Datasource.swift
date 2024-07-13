//
//  Waterfall-Datasource.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/12.
//

import Foundation

extension WaterfallVC {
    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        if isMyDraft {
            return draftNotes.count
        } else {
            return 13
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isMyDraft {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kDraftNoteWaterfallCellID, for: indexPath) as! DraftNoteWaterfallCell
            cell.draftNote = draftNotes[indexPath.item]
            cell.deleteBtn.tag = indexPath.item
            cell.deleteBtn.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kWaterfallCellID, for: indexPath) as! WaterfallCell
            cell.imageVIew.image = UIImage(named: "\(indexPath.item + 1)")
            return cell
        }
    }
}

// MARK: - 一般函数

extension WaterfallVC {
    private func deleteDraftNote(_ index: Int) {
        backgroundContext.perform {
            let draftNote = self.draftNotes[index]
            // 数据
            backgroundContext.delete(draftNote)

            appDelegate.saveBackgroundContext()

            self.draftNotes.remove(at: index)

            DispatchQueue.main.async {
                // UI
                self.collectionView.reloadData()
                self.showTextHUD("删除草稿成功")
            }
        }
    }
}

// MARK: - 监听

extension WaterfallVC {
    @objc private func showAlert(_ sender: UIButton) {
        let index = sender.tag

        let alert = UIAlertController(title: "提示", message: "确认删除该草稿吗？", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "取消", style: .cancel)
        let action2 = UIAlertAction(title: "确认", style: .destructive) { _ in
            self.deleteDraftNote(index)
        }
        alert.addAction(action1)
        alert.addAction(action2)

        present(alert, animated: true)
    }
}
