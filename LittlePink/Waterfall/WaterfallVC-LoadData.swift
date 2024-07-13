//
//  WaterfallVC-LoadData.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/12.
//

import CoreData

extension WaterfallVC {
    func getDraftNotes() {
        let request = DraftNote.fetchRequest() as NSFetchRequest<DraftNote>
        // request.fetchOffset = 0
        // request.fetchLimit = 20

        // 筛选
        // request.predicate = NSPredicate(format: "title = %@", "IOS")

        let sortDescriptor1 = NSSortDescriptor(key: "updateAt", ascending: false)
        request.sortDescriptors = [sortDescriptor1]

        request.propertiesToFetch = ["coverPhoto", "title", "updateAt", "isVideo"]

        showLoadHUD()
        backgroundContext.perform {
            if let draftNotes = try? backgroundContext.fetch(request) {
                self.draftNotes = draftNotes
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            self.hideLoadHUD()
        }
    }
}
