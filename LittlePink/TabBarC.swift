//
//  TabBarC.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/9.
//

import UIKit
import YPImagePicker

class TabBarC: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }

    func tabBarController(_: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is PostVC {
            var config = YPImagePickerConfiguration()

            // 待做 是否登陆

            // MARK: 通用配置

            config.isScrollToChangeModesEnabled = false
            config.onlySquareImagesFromCamera = false
            config.albumName = Bundle.main.appName

            config.startOnScreen = .library
            config.screens = [.library, .video, .photo]
            config.maxCameraZoomFactor = kMaxCameraZoomFactor

            // MARK: 相册配置

            // 允许一个笔记发布单个视频或多张照片
            config.library.defaultMultipleSelection = true
            config.library.maxNumberOfItems = kMaxPhotoCount
            config.library.spacingBetweenItems = kSpacingBetweenItems

            config.gallery.hidesRemoveButton = false

            // MARK: 视频配置(默认)

            let picker = YPImagePicker(configuration: config)

            picker.didFinishPicking { [unowned picker] items, cancelled in

                if cancelled {
                    picker.dismiss(animated: true)
                } else {

                    var photos: [UIImage] = []
                    var videoURL: URL?

                    for item in items {
                        switch item {
                        case let .photo(p: photo):
                            photos.append(photo.image)
                        case let .video(v: video):
                            // let url = URL(fileURLWithPath: "recordedVideoRAW.mov", relativeTo: FileManager.default.temporaryDirectory)
                            // photos.append(url.thumbnail)
                            photos.append(video.thumbnail)
                            videoURL = video.url
                        }
                    }

                    let vc = self.storyboard?.instantiateViewController(identifier: kNoteEditVCID) as! NoteEditVC
                    vc.photos = photos
                    vc.videoURL = videoURL
                    picker.pushViewController(vc, animated: true)

                }
            }
            present(picker, animated: true, completion: nil)

            return false
        }
        return true
    }
}
