//
//  NoteEditVC.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/10.
//

import UIKit

// MARK: - NoteEditVC

class NoteEditVC: UIViewController {
    var draftNote: DraftNote?

    var updateDraftNoteFinished: (() -> ())?

    var photos = [
        UIImage(named: "1")!, UIImage(named: "2")!,
    ]

    // var videoURL: URL? = Bundle.main.url(forResource: "TV", withExtension: "mp4")
    var videoURL: URL?

    var channel = ""
    var subChannel = ""
    var poiName = ""
    var poiLocation = ""

    let locationManager = CLLocationManager()

    @IBOutlet
    var photoCollectionView: UICollectionView!
    @IBOutlet
    var titleTextField: UITextField!
    @IBOutlet
    var titleCountLabel: UILabel!
    @IBOutlet
    var textView: UITextView!
    @IBOutlet
    var channelIcon: UIImageView!
    @IBOutlet
    var channelLabel: UILabel!
    @IBOutlet
    var channelPlaceholderLabel: UILabel!

    @IBOutlet
    var poiNameIcon: UIImageView!
    @IBOutlet
    var poiNameLabel: UILabel!

    var textViewIAView: TextViewIAView { textView.inputAccessoryView as! TextViewIAView }

    var photoCount: Int { photos.count }

    var isVideo: Bool { videoURL != nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setUI()

        // print(NSHomeDirectory())
        // print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, false)[0])
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
    }

    @IBAction
    func TFEditBegin(_: Any) {
        titleCountLabel.isHidden = false
    }

    @IBAction
    func TFEditEnd(_: Any) {
        titleCountLabel.isHidden = true
    }

    @IBAction
    func TFEndOnExit(_: Any) {}

    @IBAction
    func TFEditChanged(_: Any) {
        handleTFEditChanged()
    }

    // MARK: - 存草稿

    @IBAction
    func saveDraftNote(_: Any) {
        guard isValidateNote() else { return }

        if let draftNote = draftNote {
            updateDraftNote(draftNote)
        } else {
            createDraftNote()
        }
    }

    @IBAction
    func postNote(_: Any) {
        guard isValidateNote() else { return }
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if let channelVC = segue.destination as? ChannelVC {
            view.endEditing(true)
            channelVC.pvDelegate = self
        } else if let poiVC = segue.destination as? POIVC {
            poiVC.delegate = self
            poiVC.poiName = poiName
            poiVC.poiLocation = poiLocation
        }
    }
}

// MARK: UITextViewDelegate

extension NoteEditVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard textView.markedTextRange == nil else { return }
        textViewIAView.currentTextCount = textView.text.count
    }
}

// MARK: ChannelVCDelegate

extension NoteEditVC: ChannelVCDelegate {
    func updateChannel(channel: String, subChannel: String) {
        // 数据
        self.channel = channel
        self.subChannel = subChannel

        // UI
        updateChannelUI()
    }
}

// MARK: POIVCDelegate

extension NoteEditVC: POIVCDelegate {
    func updatePOIName(_ poiName: String, _ poiLocation: String) {
        // 数据
        if poiName == kPOIsInitArr[0][0] {
            self.poiName = ""
            self.poiLocation = ""
            // UI
            updatePOINameUI()
        } else {
            self.poiName = poiName
            self.poiLocation = poiLocation
            // UI
            updatePOINameUI()
        }
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
