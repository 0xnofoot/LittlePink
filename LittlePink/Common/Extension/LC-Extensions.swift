//
//  LC-Extensions.swift
//  LittlePink
//
//  Created by toofonwang on 2024/07/15.
//

import LeanCloud

extension LCFile{
    //把文件存入某个字段
    func save(to table: LCObject, as record: String, group: DispatchGroup? = nil){
        group?.enter()
        self.save { result in
            switch result {
            case .success:
                if let _ = self.objectId?.value {
                    //print("文件保存完成。objectId: \(value)")
                    do {
                        try table.set(record, value: self)
                        group?.enter()
                        table.save { (result) in
                            switch result {
                            case .success:
                                //print("文件已关联/文件已存入\(record)字段")
                                break
                            case .failure(error: let error):
                                print("保存表的数据失败: \(error)")
                            }
                            group?.leave()
                        }
                    } catch {
                        print("给User表的字段赋值失败: \(error)")
                    }
                }
            case .failure(error: let error):
                // 保存失败，可能是文件无法被读取，或者上传过程中出现问题
                print("保存文件进云端失败: \(error)")
            }
            group?.leave()
        }
    }
}

extension LCObject{
    func getExactStringVal(_ col: String) -> String { get(col)?.stringValue ?? "" }
    func getExactIntVal(_ col: String) -> Int { get(col)?.intValue ?? 0 }
    func getExactDoubelVal(_ col: String) -> Double { get(col)?.doubleValue ?? 1 }//这里取1,方便大多数情况使用
    func getExactBoolVal(_ col: String) -> Bool { get(col)?.boolValue ?? false }//仅少数地方用(如性别)
    
    enum imageType {
        case avater
        case coverPhoto
    }
    //从云端的某个file(image类型)字段取出path再变成URL
    func getImageURL(from col: String, _ type: imageType) -> URL{
        if let file = get(col) as? LCFile, let path = file.url?.stringValue, let url = URL(string: path) {
            return url
        }else{
            switch type{
            case .avater:
                return Bundle.main.url(forResource: "avatarPH", withExtension: "jpeg")!
            case .coverPhoto:
                return Bundle.main.url(forResource: "imagePH", withExtension: "png")!
            }
        }
    }
}
