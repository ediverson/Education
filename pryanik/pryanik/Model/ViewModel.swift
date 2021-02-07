import Foundation
import Alamofire

class ViewModel {
    var value: ServerData = ServerData()
    var new: [DataFirstLevel] = []
    weak var vc: ViewController?

//MARK: -Requared order
    func order(){
        let needOrder = value.view
        let weHave = value.data
        guard needOrder != nil && weHave != nil else { return }
        
        for el in needOrder!{
            for value in weHave!{
                if el == value.name{
                    new.append(value)
                }
            }
        }
    }
    
//MARK: -Json
    func request(){
        AF.request("https://pryaniky.com/static/json/sample.json").responseJSON{ response in
            let decoder = JSONDecoder()
                    do{
                        self.value = try decoder.decode(ServerData.self, from: response.data!)
                            DispatchQueue.main.async {
                                self.vc?.tableView.reloadData()
                                self.order()
                        }
                 } catch{
                         print(error)
                 }
        }
    }
}
