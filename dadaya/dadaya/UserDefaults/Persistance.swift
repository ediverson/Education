import Foundation

class Persistance{
    static let shared = Persistance()
    
    private let kUserNameKey = "Persistance.kUserNameKey"
    private let kSecondUserNameKey = "Persistance.kSecondUserNameKey"
    
    
    var userName: String? {
        set { UserDefaults.standard.set(newValue, forKey: kUserNameKey) }
        get { return UserDefaults.standard.string(forKey: kUserNameKey)}
    }
    
    var userSecondName: String? {
        set { UserDefaults.standard.set(newValue, forKey: kSecondUserNameKey) }
        get { return UserDefaults.standard.string(forKey: kSecondUserNameKey)}
    }
}
