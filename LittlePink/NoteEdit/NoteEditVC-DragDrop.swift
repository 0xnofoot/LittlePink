//
//  NoteEditVC-DragDrop.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/10.
//

import Foundation

extension NoteEditVC: UICollectionViewDragDelegate {
    func collectionView(_: UICollectionView, itemsForBeginning _: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let photo = photos[indexPath.item]

        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: photo))
        dragItem.localObject = photo

        return [dragItem]
    }
}

extension NoteEditVC: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate _: UIDropSession, withDestinationIndexPath _: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        if coordinator.proposal.operation == .move,
           let item = coordinator.items.first,
           let sourceIndexPath = item.sourceIndexPath,
           let destinationIndex = coordinator.destinationIndexPath
        {
            collectionView.performBatchUpdates {
                photos.remove(at: sourceIndexPath.item)
                photos.insert(item.dragItem.localObject as! UIImage, at: destinationIndex.item)
                collectionView.moveItem(at: sourceIndexPath, to: destinationIndex)
            }
            coordinator.drop(item.dragItem, toItemAt: destinationIndex)
        }
    }
}
