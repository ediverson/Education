import UIKit
import Alamofire
import RealmSwift

class WeatherViewController: UIViewController{
    
    //MARK: - Values
    var weather = WData()
    let realm = try! Realm()
    var weathers: Results<WData>!
    let dateFormatter = DateFormatter()
    
    //MARK: - Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    //MARK: - View creator
    func update(data: WData){
        
        if data == weather{
            cityNameLabel.text = "No data \n Press refresh button"
            cityNameLabel.font = UIFont(name: "System", size: 20)
        }else if weathers != nil{
//            cityNameLabel.font = UIFont(name: "System", size: 45)
            cityNameLabel.text = data.name
            dateLabel.text = "Дата \n \(dateFormatter.string(from: Date(timeIntervalSinceReferenceDate: data.dt)))"
            feelsLikeLabel.text = "Средняя температура \n \(data.main!.feelsLike) °"
            tempLabel.text = "Температура \n \(data.main!.temp) °"
            tempMaxLabel.text = "Мин. температура \n \(data.main!.tempMax) °"
            tempMinLabel.text = "Макс. температура \n \(data.main!.tempMin) °"
            pressureLabel.text = "Давление \n \(data.main!.pressure) мм рт. ст."
            windSpeedLabel.text = "Скорость ветра \n \(data.wind!.speed) м/с"
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        let realm = try! Realm()
        weathers = realm.objects(WData.self)
        
        update(data: weathers.first ?? weather)
    }
    
    //MARK: - JSON method
    func loadWeather(for api: String){
        Alamofire.request(api).responseJSON{ response in
                let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                do{
                    self.weather = try decoder.decode(WData.self, from: response.data!)
                    DispatchQueue.main.async {
                        
                        try! self.realm.write(){
                            self.realm.add(self.weather)
                        }
                        try! self.realm.write(){
                            if self.weathers.count > 1{
                                self.realm.delete(self.weathers.first!)
                            }
                        }
                        self.update(data: self.weathers.last ?? self.weather)
                    }
                } catch{
                    print(error)
                }
            }
    }
  
    

    //MARK: - Create button
    @IBAction func refreshButton(_ sender: Any) {
        if weathers != nil{
            
            if Tap.shere.isTapped == false{
            loadWeather(for: "https://api.openweathermap.org/data/2.5/weather?q=malibu&units=metric&lang=ru&appid=43449a0aa8d8e83d8e3b52f61122599f")

            Tap.shere.isTapped = true
        }else if Tap.shere.isTapped == true{
            loadWeather(for: "https://api.openweathermap.org/data/2.5/weather?q=moscow&units=metric&lang=ru&appid=43449a0aa8d8e83d8e3b52f61122599f")
            Tap.shere.isTapped = false
            
            }
        }
    }
}

