import Foundation
import RealmSwift

class Task: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var isComplited: Bool = false
}
