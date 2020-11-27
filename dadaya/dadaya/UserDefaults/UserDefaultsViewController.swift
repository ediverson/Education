import UIKit

class UserDefaultsViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var secondNameTextField: UITextField!
    
    @IBOutlet weak var greetingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        greeting()
        }
    
    func greeting(){
        greetingLabel.text = "Привет \n \(String(describing: Persistance.shared.userSecondName ?? "")) \(String(describing: Persistance.shared.userName ?? ""))"
        
    }
    
    @IBAction func greetingButton(_ sender: Any) {
        Persistance.shared.userName = nameTextField.text
        Persistance.shared.userSecondName = secondNameTextField.text
        
        greeting()
    }
}
