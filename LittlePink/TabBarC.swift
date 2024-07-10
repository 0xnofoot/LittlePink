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
                    print("用户按下了左上角取消按钮")
                }

                for item in items {
                    switch item {
                    case let .photo(p: photo):
                        print(photo)
                    case let .video(v: video):
                        print(video)
                    }
                }

                picker.dismiss(animated: true, completion: nil)
            }
            present(picker, animated: true, completion: nil)

            return false
        }
        return true
    }
}
