//
//  NoteEditVC.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/10.
//

import UIKit

class NoteEditVC: UIViewController {
    var photos = [
        UIImage(named: "1")!, UIImage(named: "2")!,
    ]

    var videoURL: URL?

    var channel = ""
    var subChannel = ""

    var textViewIAView: TextViewIAView { textView.inputAccessoryView as! TextViewIAView }

    @IBOutlet var photoCollectionView: UICollectionView!

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var titleCountLabel: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet weak var channelIcon: UIImageView!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var channelPlaceholderLabel: UILabel!

    var photoCount: Int { photos.count }

    var isVideo: Bool { videoURL != nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }

    @IBAction func TFEditBegin(_: Any) {
        titleCountLabel.isHidden = false
    }

    @IBAction func TFEditEnd(_: Any) {
        titleCountLabel.isHidden = true
    }

    @IBAction func TFEndOnExit(_: Any) {}

    @IBAction func TFEditChanged(_: Any) {
        guard titleTextField.markedTextRange == nil else { return }
        if titleTextField.unwrappedText.count > kMAxNoteTitleCount {
            titleTextField.text = String(titleTextField.unwrappedText.prefix(kMAxNoteTitleCount))

            DispatchQueue.main.async {
                let end = self.titleTextField.endOfDocument
                self.titleTextField.selectedTextRange = self.titleTextField.textRange(from: end, to: end)
            }
        }
        titleCountLabel.text = "\(kMAxNoteTitleCount - titleTextField.unwrappedText.count)"
    }

    // MARK 待做（存草稿和发布笔记之前需判断当前用户输入的正文文本数量，看是否大于最大可输入数量）

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let channelVC = segue.destination as? ChannelVC {
            channelVC.pvDelegate = self
        }
    }
}

extension NoteEditVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard textView.markedTextRange == nil else { return }
        textViewIAView.currentTextCount = textView.text.count
    }
}

extension NoteEditVC: ChannelVCDelegate {
    func updateChannel(channel: String, subChannel: String) {
        // 数据
        self.channel = channel
        self.subChannel = subChannel

        // UI
        channelLabel.text = subChannel
        channelIcon.tintColor = blueColor
        channelLabel.textColor = blueColor
        channelPlaceholderLabel.isHidden = true
    }
}

// extension NoteEditVC: UITextFieldDelegate {
//     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//         let isExceed = range.location >= kMAxNoteTitleCount || (textField.unwrappedText.count + string.count) > kMAxNoteTitleCount
//
//         if isExceed {
//             showTextHUD("标题最多输入\(kMAxNoteTitleCount)个字哦")
//         }
//
//         return !isExceed
//     }
// }
