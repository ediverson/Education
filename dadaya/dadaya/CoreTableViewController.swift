import UIKit
import CoreData

class CoreTableViewController: UITableViewController, NSFetchedResultsControllerDelegate{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    var fetchedResultsController: NSFetchedResultsController<User>!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let sotrDescritor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.fetchLimit = 15
        fetchRequest.sortDescriptors = [sotrDescritor]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        try! fetchedResultsController.performFetch()
        
    }

    // MARK: - Button
    @IBAction func addButton(_ sender: Any) {
        let user = User(context: appDelegate.persistentContainer.viewContext)
        user.name = "User: \(userNameTextField.text ?? "")"
        
        fetchedResultsController.delegate = self
        
        appDelegate.saveContext()
        userNameTextField.text = ""
        
        tableView.reloadData()
    }
    
    // MARK: - Controller
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            
            if indexPath != nil{
                tableView.insertRows(at: [indexPath!], with: .fade)
            }
            
        case .delete:
            
            tableView.deleteRows(at: [indexPath!], with: .middle)
        
        case .update:
            
            tableView.reloadRows(at: [indexPath!], with: .automatic)
            
            default:
                break
        }
    }
    
    
    // MARK: - Table view

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = fetchedResultsController.sections?[section]
        
        return sectionInfo?.numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let user = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = user.name
        

        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var didComplite = fetchedResultsController.object(at: indexPath).complete
        if didComplite == false{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            didComplite = true
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            didComplite = false
        }
        tableView.reloadData()
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = fetchedResultsController.object(at: indexPath)
            appDelegate.persistentContainer.viewContext.delete(user)
            
            appDelegate.saveContext()
        }
    }
}
