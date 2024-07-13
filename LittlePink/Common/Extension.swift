//
//  Extension.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/9.
//

import AVFoundation
import DateToolsSwift
import Foundation
import UIKit

extension String {
    var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension Optional where Wrapped == String {
    var unwrappedText: String { self ?? "" }
}

extension Date {
    var formattedDate: String {
        let currentYear = Date().year

        if year == currentYear { // 今年
            if isToday {
                if minutesAgo > 10 {
                    return "今天\(format(with: "HH:mm"))"
                } else {
                    return timeAgoSinceNow
                }
            } else if isYesterday {
                return "昨天 \(format(with: "HH:mm"))"
            } else {
                return format(with: "MM-dd")
            }
        } else if year < currentYear { // 去年或更早
            return format(with: "yyyy-MM-dd")
        } else { //
            return "明年或更远，目前项目暂时不会用到"
        }
    }
}

extension URL {
    var thumbnail: UIImage {
        let asset = AVAsset(url: self)
        let assetIgmgGenerate = AVAssetImageGenerator(asset: asset)
        assetIgmgGenerate.appliesPreferredTrackTransform = true

        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
        do {
            let img = try assetIgmgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            return imagePH
        }
    }
}

extension UIImage {
    convenience init?(_ data: Data?) {
        if let unwrappedData = data {
            self.init(data: unwrappedData)
        } else {
            return nil
        }
    }

    enum JPEGQuality: CGFloat {
        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
    }

    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

extension UITextField {
    var unwrappedText: String { text ?? "" }
    var exactText: String {
        unwrappedText.isBlank ? "" : unwrappedText
    }
}

extension UITextView {
    var unwrappedText: String { text ?? "" }
    var exactText: String {
        unwrappedText.isBlank ? "" : unwrappedText
    }
}

extension UIView {
    @IBInspectable
    var radius: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}

extension UIViewController {
    // MARK: - 展示加载框或提示框

    // MARK：加载框--手动隐藏
    func showLoadHUD(_ title: String? = nil) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = title
    }

    func hideLoadHUD() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

    // MARK：提示框--自动隐藏
    func showTextHUD(_ title: String, _ inCurrentView: Bool = true, _ subTitle: String? = nil) {
        var viewToShow = view!

        if !inCurrentView {
            // viewToShow = UIApplication.shared.windows.last!
            viewToShow = (view.window?.windowScene?.windows.last)!
        }

        let hud = MBProgressHUD.showAdded(to: viewToShow, animated: true)
        hud.mode = .text
        hud.label.text = title
        hud.detailsLabel.text = subTitle
        hud.hide(animated: true, afterDelay: 2)
    }

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension Bundle {
    var appName: String {
        if let appName = localizedInfoDictionary?["CFBundleDisplayName"] as? String {
            return appName
        } else {
            return infoDictionary!["CFBundleDisplayName"] as! String
        }
    }

    static func loadView<T>(fromNib name: String, with type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }
        fatalError("加载\(type)类型的view失败")
    }
}

extension FileManager {
    func save(_ data: Data?, to dirName: String, as fileName: String) -> URL? {
        guard let data = data else {
            print("要写入的data为nil")
            return nil
        }

        let dirURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(dirName, isDirectory: true)

        if !fileExists(atPath: dirURL.path) {
            guard let _ = try? createDirectory(at: dirURL, withIntermediateDirectories: true) else {
                print("创建文件夹失败")
                return nil
            }
        }

        let fileURL = dirURL.appendingPathComponent(fileName)

        if !fileExists(atPath: fileURL.path) {
            guard let _ = try? data.write(to: fileURL) else {
                print("写入/保存文件失败")
                return nil
            }
        }

        return fileURL
    }
}
