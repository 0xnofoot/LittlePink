//
//  MeVC.swift
//  LittlePink
//
//  Created by toofonwang on 2024/7/13.
//

import UIKit
import LeanCloud

class MeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //iOS14之前去掉返回按钮文本的话需:
        //1.sb上:上一个vc(MeVC)的navigationitem中修改为空格字符串串
        //2.代码:上一个vc(此页)navigationItem.backButtonTitle = ""
        navigationItem.backButtonDisplayMode = .minimal
    }

}
