//
//  Login-Extensions.swift
//  LittlePink
//
//  Created by toofonwang on 2024/07/15.
//

import LeanCloud

extension UIViewController{
    func configAfterLogin(_ user: LCUser, _ nickName: String, _ email: String = ""){
        if let _ = user.get(kNickNameCol){
            dismissAndShowMeVC()
        }else{//首次登录(即注册)
            //enter和leave成对出现,全部配对成功后再执行notify中内容,整个过程不会阻塞主线程(同时拥有同步和异步的好处)
            let group = DispatchGroup()
            
            let randomAvatar = UIImage(named: "avatarPH\(Int.random(in: 1...4))")!
            if let avatarData = randomAvatar.pngData(){
                let avatarFile = LCFile(payload: .data(data: avatarData))
                avatarFile.mimeType = "image/jpeg"
                
                avatarFile.save(to: user, as: kAvatarCol, group: group)
            }
            
            do {
                if email != ""{
                    user.email = LCString(email)
                }
                try user.set(kNickNameCol, value: nickName)
            } catch {
                print("给User表的字段赋值失败: \(error)")
                return
            }
            
            group.enter()
            user.save { _ in group.leave() }
            
            group.notify(queue: .main) {
                self.dismissAndShowMeVC()
            }
        }
    }
    
    func dismissAndShowMeVC(){
        hideLoadHUD()
        DispatchQueue.main.async {
            let mainSB = UIStoryboard(name: "Main", bundle: nil)
            let meVC = mainSB.instantiateViewController(identifier: kMeVCID)
            loginAndMeParentVC.removeChildren()
            loginAndMeParentVC.add(child: meVC)
            
            self.dismiss(animated: true)
        }
    }
}
