import UIKit
import CoreData


class CoreViewController: UIViewController, NSFetchedResultsControllerDelegate{
    @IBOutlet weak var tableView: UITableView!
    var people: [NSManagedObject] = []
    var entity = "Person"
    
    var fetchedResultsController = CoreDataManager.share.fetchedResultsController(entity: "Person", keyForSort: "name")


    func saveNameAndState(name: String, state: Bool){
        let person = NSManagedObject.init(entity: CoreDataManager.share.entityForName(entityName: entity), insertInto: CoreDataManager.share.persistentContainer.viewContext)
        
        person.setValue(name, forKey: "name")
        person.setValue(state, forKey: "state")
        people.append(person)
            
        CoreDataManager.share.saveContext()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let fetchedRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        do{
            people = try (CoreDataManager.share.persistentContainer.viewContext.fetch(fetchedRequest) as? [NSManagedObject])!
        }catch{
            print(error)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        
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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type{
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        default:
            break
        }
        tableView.reloadData()
    }
}




    //MARK: - Table Extension
extension CoreViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = fetchedResultsController.sections?[section]
        
        return sections?.numberOfObjects ?? 0
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
        
        CoreDataManager.share.saveContext()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let object = fetchedResultsController.object(at: indexPath)
            CoreDataManager.share.persistentContainer.viewContext.delete(object as! NSManagedObject)
            
            CoreDataManager.share.saveContext()
        }
        tableView.reloadData()
    }
}
