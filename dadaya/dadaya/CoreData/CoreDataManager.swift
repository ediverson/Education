import Foundation
import CoreData

class CoreDataManager {
    static let share = CoreDataManager()
    
//MARK: - Create Entity for Name
    func entityForName(entityName: String) -> NSEntityDescription{
        return NSEntityDescription.entity(forEntityName: entityName, in: persistentContainer.viewContext)!
    }
//MARK: -Create Fetched Results Controller for Entity Name
    func fetchedResultsController(entity: String, keyForSort: String) -> NSFetchedResultsController<NSFetchRequestResult>{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: keyForSort, ascending: true)]
            
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
       
        return fetchedResultsController
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "dadaya")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

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
}
