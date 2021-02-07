import UIKit
import Alamofire
import AlamofireImage

class ViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
//Link for ViewModel
    private var model = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shrek" // ;)
        
        model.request()
        model.vc = self
    }
    
    func updateViewForRow(with indexPath: IndexPath, for vc: InfoViewController) {
        let parameter = model.new[indexPath.row]
        
        vc.title = parameter.name
        vc.name = parameter.name
        
        if parameter.data.text != nil {
            vc.text = parameter.data.text!
            
        }else {
            vc.text = ""
            
        }
        
        if parameter.data.variants != nil{
                for el in parameter.data.variants!{
                    vc.selectorItems.append(String(el.id))
                    vc.selectorText.append(el.text)
                }
            vc.createSegment()
            
        }
        guard parameter.data.url != nil  else { return }
        let url = URL(string: parameter.data.url!)
        vc.pic = url
    }
}


// MARK: -TableView extension
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
// Nubmer of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.value.view?.count ?? 0
    }
// Creating a cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.textAlignment = .center
        cell?.textLabel?.text = model.value.view?[indexPath.row]
        
        return cell!
    }

// Creating a view for each row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = storyboard?.instantiateViewController(identifier: "infoViewController") as! InfoViewController

        updateViewForRow(with: indexPath, for: vc)
        navigationController?.pushViewController(vc, animated: true)
    }
}
