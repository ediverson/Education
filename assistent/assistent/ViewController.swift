import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicker: UIImagePickerController!

// Значения для рандомных X и Y. Усложнять с высчитыванием значений для каждой загруженной фото не стал, а просто растянул фото на размер всего ImageView, но если будет надо, то сделать это не сложно
    let pointX = CGFloat(Int.random(in: 20...414))
    let pointY = CGFloat(Int.random(in: 20...500))

    @IBOutlet weak var assistentFace: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var infoLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        assistentFace.setImage(UIImage(named: "Waiting"), for: .normal)
    }
// Функция для генерации кнопок
    func createButtons(at x: CGFloat, _ y: CGFloat) {
        let button = UIButton()

        button.frame = CGRect(x: x, y: y, width: 20, height: 20)
        button.layer.cornerRadius = button.frame.width / 2
        button.backgroundColor = .systemPink
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        imageView.addSubview(button)
    }
    
    
// Просим ассистента показать доступные кнопки. Тут я сделал через рандомные точки, чтобы кнопки появлялись в разных местах, так как просили без ML моделей, а так надо, конечно, задавать точки X и Y в соответствии с найдеными объектами на фото
    @IBAction func searchButton(_ sender: Any) {
        
        if imageView.image != .none {
            createButtons(at: pointX, pointY)
            infoLable.text = " Я готов "
            assistentFace.setImage(UIImage(named: "Hello"), for: .normal)
        } else {
            infoLable.text = " Жду фото "
            assistentFace.setImage(UIImage(named: "Waiting"), for: .normal)
        }
    }
    
// Ответ бота при нажатии на кнопку. Он должен перенаправлять на поиск в гугле по названию найденого объекта
    @objc func buttonAction(sender: UIButton!) {
        let value = Int.random(in: 0...2)
        
        if value % 2 == 1 {
            infoLable.text = " О, это я знаю "
            assistentFace.setImage(UIImage(named: "I know it"), for: .normal)
        } else {
            infoLable.text = " Такого еще не встречал "
            assistentFace.setImage(UIImage(named: "I dont know it"), for: .normal)
        }
     }
    
// Кнопка создания фото через камеру
    @IBAction func insertPhotoButton(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
// Кнопка загрузки фото из галереи
    @IBAction func loadPhotoButton(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }

// Передача фото в imageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    }
}

