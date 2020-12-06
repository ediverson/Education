import UIKit
import RealmSwift

class RealmViewController: UIViewController {
    
    var tasks: Results<Task>!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        tasks = realm.objects(Task.self)
    }

   
    //MARK: - Actions
    
    @IBAction func addButton(_ sender: Any) {
        let realm = try! Realm()
        let tasks = realm.objects(Task.self)
        
        let task = Task()
        task.name = "Task \(tasks.count + 1)"
        task.isComplited = false // не обязательное поле, так как при создании объекта в классе Task мы уже указали значение
        
        try! realm.write{
        realm.add(task)
        }
        tableView.reloadData()
    }
    
    var isFilter = false
    
    @IBAction func organizeButton(_ sender: Any) {
        let realm = try! Realm()
        
        if isFilter{
            tasks = realm.objects(Task.self)
        }else{
            tasks = realm.objects(Task.self).filter("isComplited == false")
        }
        isFilter = !isFilter
        tableView.reloadData()
    }
}


//MARK: - TableView
extension RealmViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellNotes")
        let title = tasks[indexPath.row]
        
        let name = "\(title.name)"
        cell?.textLabel?.text = name
        
        if tasks[indexPath.row].isComplited == false{
            cell?.accessoryType = .none
        }else{
            cell?.accessoryType = .checkmark
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let realm = try! Realm()
        
        if tasks[indexPath.row].isComplited == false{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            try! realm.write{
            tasks[indexPath.row].isComplited = true
            }
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            try! realm.write{
            tasks[indexPath.row].isComplited = false
            }
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            let realm = try! Realm()
            let item = tasks[indexPath.row]
            try! realm.write{
            realm.delete(item)
            }
            tableView.reloadData()
            
        }
    }
    
}
