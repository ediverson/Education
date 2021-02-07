import Foundation

//MARK: -Entity for Json
struct Variants: Codable {
    var id: Int = 0
    var text: String = ""
}

struct DataSecondLevel: Codable {
    var text: String? = ""
    var url: String? = ""
    var selectedId: Int? = 0
    var variants: [Variants]? = []
}

struct DataFirstLevel: Codable {
    var name: String = ""
    var data: DataSecondLevel = DataSecondLevel()
}

struct ServerData: Codable {
    var data: [DataFirstLevel]? = []
    var view: [String]? = []
}
