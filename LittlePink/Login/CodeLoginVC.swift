//
//  CodeLoginVC.swift
//  LittlePink
//
//  Created by toofonwang on 2024/07/15.
//

import LeanCloud
import UIKit

private let totalTime = 10

// MARK: - CodeLoginVC

class CodeLoginVC: UIViewController {
    // MARK: Internal

    @IBOutlet
    weak var phoneNumTF: UITextField!
    @IBOutlet
    weak var authCodeTF: UITextField!
    @IBOutlet
    weak var getAuthCodeBtn: UIButton!
    @IBOutlet
    weak var loginBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()

        loginBtn.setToDisabled()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        phoneNumTF.becomeFirstResponder()
    }

    @IBAction
    func dismiss(_ sender: Any) { dismiss(animated: true) }

    @IBAction
    func TFEditingChanged(_ sender: UITextField) {
        if sender == phoneNumTF {
            getAuthCodeBtn.isHidden = !phoneNumStr.isPhoneNum && getAuthCodeBtn.isEnabled
        }

        if phoneNumStr.isPhoneNum && authCodeStr.isAuthCode {
            loginBtn.setToEnabled()
        } else {
            loginBtn.setToDisabled()
        }
    }

    @IBAction
    func getAuthCode(_ sender: Any) {
        getAuthCodeBtn.isEnabled = false
        setAuthCodeBtnDisabledText()
        authCodeTF.becomeFirstResponder()

        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(changeAuthCodeBtnText),
            userInfo: nil,
            repeats: true
        )

        let variables: LCDictionary = [
            "ttl": LCNumber(10), // 验证码有效时间为 10 分钟
            "name": LCString("小粉书"), // 应用名称
            "op": LCString("登录"), // 操作名称
        ]

        _ = LCSMSClient
            .requestShortMessage(mobilePhoneNumber: phoneNumStr, variables: variables) { result in
                if case let .failure(error: error) = result {
                    print(error.reason ?? "未知错误")
                }
            }
    }

    @IBAction
    func login(_ sender: UIButton) {
        print("login")
    }

    // MARK: Private

    lazy private var timer = Timer()

    private var timeRemain = totalTime

    private var phoneNumStr: String { phoneNumTF.unwrappedText }
    private var authCodeStr: String { authCodeTF.unwrappedText }
}

// MARK: UITextFieldDelegate

extension CodeLoginVC: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    )
        -> Bool {
        let limit = textField == phoneNumTF ? 11 : 6
        let isExceed = range.location >= limit
            || (textField.unwrappedText.count + string.count) > limit

        // if isExceed {
        //     showTextHUD("只能输入11位电话号码")
        // }

        return !isExceed
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == phoneNumTF {
            authCodeTF.becomeFirstResponder()
        } else {
            if loginBtn.isEnabled {
                login(loginBtn)
            }
        }

        return true
    }
}

extension CodeLoginVC {
    @objc
    private func changeAuthCodeBtnText() {
        timeRemain -= 1
        setAuthCodeBtnDisabledText()

        if timeRemain <= 0 {
            timer.invalidate()
            timeRemain = totalTime
            getAuthCodeBtn.isEnabled = true
            getAuthCodeBtn.setTitle("发送验证码", for: .normal)

            getAuthCodeBtn.isHidden = !phoneNumStr.isPhoneNum
        }
    }
}

extension CodeLoginVC {
    func setAuthCodeBtnDisabledText() {
        getAuthCodeBtn.setTitle("重新发送\(timeRemain)", for: .disabled)
    }
}
