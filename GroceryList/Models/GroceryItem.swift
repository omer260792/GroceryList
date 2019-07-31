
import Foundation
import Firebase

struct GroceryItem {
    
    let ref: DatabaseReference?
    let key: String
    let name: String
    let content: String
    let date: String
    let tabCategory: String
    let generalCategory: String
    let image: String
    let isColor: Bool
    let isSend: Bool
    var isCompleted: Bool
    let uid: String
    
    init(name: String, content: String, date: String, tabCategory: String, generalCategory: String, image: String, isSend: Bool, isColor: Bool, isCompleted: Bool, uid: String, key: String = "") {
        self.ref = nil
        self.key = key
        self.name = name
        self.content = content
        self.date = date
        self.tabCategory = tabCategory
        self.generalCategory = generalCategory
        self.image = image
        self.isSend = isSend
        self.isColor = isColor
        self.isCompleted = isCompleted
        self.uid = uid
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let content = value["content"] as? String,
            let date = value["date"] as? String,
            let tabCategory = value["tabCategory"] as? String,
            let generalCategory = value["generalCategory"] as? String,
            let image = value["image"] as? String,
            let isSend = value["isSend"] as? Bool,
            let isColor = value["isColor"] as? Bool,
            let uid = value["uid"] as? String,
            let isCompleted = value["isCompleted"] as? Bool else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.name = name
        self.content = content
        self.date = date
        self.tabCategory = tabCategory
        self.generalCategory = generalCategory
        self.image = image
        self.isSend = isSend
        self.isColor = isColor
        self.isCompleted = isCompleted
        self.uid = uid
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "content": content,
            "date": date,
            "tabCategory": tabCategory,
            "generalCategory": generalCategory,
            "image": image,
            "isSend": isSend,
            "isColor": isColor,
            "isCompleted": isCompleted,
            "uid": uid
        ]
    }
}
