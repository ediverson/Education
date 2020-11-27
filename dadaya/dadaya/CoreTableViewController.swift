import UIKit
import CoreData

var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "dadaya")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    return container
}()

func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

class CoreTableViewController: UITableViewController, NSFetchedResultsControllerDelegate{
        
    @IBOutlet weak var userNameTextField: UITextField!
    
    var fetchedResultsController: NSFetchedResultsController<User>!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let sotrDescritor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.fetchLimit = 15
        fetchRequest.sortDescriptors = [sotrDescritor]

        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        try! fetchedResultsController.performFetch()
        
    }

    
    @IBAction func addButton(_ sender: Any) {
        let user = User(context: persistentContainer.viewContext)
        user.name = "User: \(userNameTextField.text ?? "noname")"
        
        fetchedResultsController.delegate = self
        
        saveContext()
        tableView.reloadData()
        userNameTextField.text = ""
    }
    
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

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = fetchedResultsController.object(at: indexPath)
            persistentContainer.viewContext.delete(user)
            
            saveContext()
        }
    }
}
