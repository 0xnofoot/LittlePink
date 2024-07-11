//
//  NoteEditVC-CollectionView.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/10.
//

import AVKit
import SKPhotoBrowser
import YPImagePicker

extension NoteEditVC: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return photoCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPhotoCellID, for: indexPath) as! PhotoCell

        cell.imageView.image = photos[indexPath.item]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let photofooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kPhotoFooterID, for: indexPath) as! PhotoFooter
            photofooter.addPhotoBtn.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
            return photofooter
        default:
            fatalError("collectionView的footer出问题了")
        }
    }
}

// MARK: - SKPhotoBrowserDelegate

extension NoteEditVC: SKPhotoBrowserDelegate {
    func removePhoto(_: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        photos.remove(at: index)
        photoCollectionView.reloadData()
        reload()
    }
}

extension NoteEditVC: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isVideo {
            let playerVC = AVPlayerViewController()
            playerVC.player = AVPlayer(url: videoURL!)
            present(playerVC, animated: true) {
                playerVC.player?.play()
            }
        } else {
            // 1. create SKPhoto Array from UIImage
            var images: [SKPhoto] = []
            for photo in photos {
                images.append(SKPhoto.photoWithImage(photo))
            }
            // 2. create PhotoBrowser Instance, and present from your viewController.
            let browser = SKPhotoBrowser(photos: images, initialPageIndex: indexPath.item)
            browser.delegate = self
            SKPhotoBrowserOptions.displayAction = false
            SKPhotoBrowserOptions.displayDeleteButton = true
            present(browser, animated: true)
        }
    }
}

// MARK: - 监听

extension NoteEditVC {
    @objc private func addPhoto() {
        if photoCount < kMaxPhotoCount {
            var config = YPImagePickerConfiguration()

            // MARK: 通用配置

            config.albumName = Bundle.main.appName
            config.screens = [.library]

            // MARK: 相册配置

            // 允许一个笔记发布单个视频或多张照片
            config.library.defaultMultipleSelection = true
            config.library.maxNumberOfItems = kMaxPhotoCount - photoCount
            config.library.spacingBetweenItems = kSpacingBetweenItems

            config.gallery.hidesRemoveButton = false

            // MARK: 视频配置(默认)

            let picker = YPImagePicker(configuration: config)

            picker.didFinishPicking { [unowned picker] items, _ in
                for item in items {
                    if case let .photo(photo) = item {
                        self.photos.append(photo.image)
                    }
                }

                self.photoCollectionView.reloadData()

                picker.dismiss(animated: true)
            }
            present(picker, animated: true)
        } else {
            showTextHUD("最多只能选择\(kMaxPhotoCount)张照片哦")
        }
    }
}
