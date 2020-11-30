import UIKit
import CoreData


class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var people: [NSManagedObject] = []
    var isDone = false

    func saveNameAndState(name: String, state: Bool){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)
        let person = NSManagedObject.init(entity: entity!, insertInto: context)
        
        person.setValue(name, forKey: "name")
        person.setValue(state, forKey: "state")
        
        if context.hasChanges{
            do{
                try context.save()
                people.append(person)
            }catch{
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchedRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        
        do{
            people = try (context.fetch(fetchedRequest) as? [NSManagedObject])!
        }catch{
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"The List\""
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        }

    //MARK: - Button
    @IBAction func addButton(_ sender: Any) {
        let alert = UIAlertController(title: "New name", message: "Add a new name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action: UIAlertAction!) in
            let textField = alert.textFields![0]
            self.saveNameAndState(name: textField.text ?? "An empty field", state: false)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in }
        
        alert.addTextField { _ in }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

    //MARK: - Extension
extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        people.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        let person = people[indexPath.row]
        
        
        cell.textLabel?.text = person.value(forKey: "name") as? String
        if person.value(forKey: "state") as? Bool == true{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = people[indexPath.row]
                
        if person.value(forKey: "state") as! Bool == false {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            person.setValue(true, forKey: "state")
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            person.setValue(false, forKey: "state")
        }
        print(person)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
        tableView.reloadData()
    }
}
