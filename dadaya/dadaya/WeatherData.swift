import Foundation
import RealmSwift

class Wind: Object, Codable{
    @objc dynamic var speed: Double = 0.0
}

//class Weather: Object, Codable{
//    @objc dynamic var description: String = ""
//}

class Main: Object, Codable {
    @objc dynamic var temp: Double = 0.0
    @objc dynamic var feelsLike: Double = 0.0
    @objc dynamic var tempMax: Double = 0.0
    @objc dynamic var tempMin: Double = 0.0
    @objc dynamic var pressure: Double = 0.0

    enum Keyes: String, CodingKey {
        case temp = "temp"
        case feelsLike = "feels_like"
        case tempMax = "temp_max"
        case tempMin = "temp_min"
        case pressure = "pressure"
    }

}

class WData: Object, Codable{
    @objc dynamic var name: String = ""
//    @objc dynamic var weather: [Weather] = []
    @objc dynamic var main: Main? = Main()
    @objc dynamic var wind: Wind? = Wind()
    @objc dynamic var dt: Double = 0.0
    
}

class Tap: Object {
    @objc dynamic var isTapped: Bool = false
}
