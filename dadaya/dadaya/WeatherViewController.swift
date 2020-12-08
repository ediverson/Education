import UIKit
import Alamofire
import RealmSwift

class WeatherViewController: UIViewController{
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    var weather = WData()
    let realm = try! Realm()
    var weathers: Results<WData>!
    
    func update(data: WData){

        cityNameLabel.text = data.name
        tempLabel.text = "Температура \n" + data.main!.temp.description + "°"
        pressureLabel.text = "Давление \n" + data.main!.pressure.description + " мм рт. ст."
        tempMinLabel.text = "Макс. температура \n" + data.main!.tempMin.description + "°"
        tempMaxLabel.text = "Мин. температура \n" + data.main!.tempMax.description + "°"
        feelsLikeLabel.text = "Средняя температура \n" + data.main!.feelsLike.description + "°"
        windSpeedLabel.text = "Скорость ветра \n" + data.wind!.speed.description + " м/с"
//        descriptionLabel.text = "\(weather.weather[0].description)"
        dateLabel.text = "Дата \n\(dateFormatter.string(from: Date(timeIntervalSinceReferenceDate: data.dt)))"
        
    }
    
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        let realm = try! Realm()
        weathers = realm.objects(WData.self)
        
        if weathers != nil{
            update(data: weathers.first!)
        }
        
        print(self.weathers.count)
        
    }

    func loadWeather(for api: String){
        Alamofire.request(api).responseJSON{ response in
//            sleep(5)
                let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                do{
                    self.weather = try decoder.decode(WData.self, from: response.data!)
                    DispatchQueue.main.async {
                        self.update(data: self.weathers.first!)
                        
                       try! self.realm.write(){
                        self.realm.add(self.weather)
                       }
                        
                        try! self.realm.write(){
                            if self.weathers.count > 1{
                                self.realm.delete(self.weathers.first!)
                            }
                        }
                        print(self.weathers.first?.name, api)
                    }
                } catch{
                    print(error)
                }
            }
    }
  
    
    var isTapped = false
    
    @IBAction func refreshButton(_ sender: Any) {
        
        if isTapped == false{
            loadWeather(for: "https://api.openweathermap.org/data/2.5/weather?q=malibu&units=metric&lang=ru&appid=43449a0aa8d8e83d8e3b52f61122599f")
            isTapped = true
            print(isTapped)
        }else{
            loadWeather(for: "https://api.openweathermap.org/data/2.5/weather?q=moscow&units=metric&lang=ru&appid=43449a0aa8d8e83d8e3b52f61122599f")
            isTapped = false
            print(isTapped)
        }
    }
}

