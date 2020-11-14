//
//  StorageManager.swift
//  EventLists
//
//  Created by YOU-HSUAN YU on 2020/11/14.
//

import Foundation
import CoreData

protocol StorageManagerProtocol {
    func checkIfExisted(model: EventModel, completion: (Result<Bool, StorageError>) -> Void)
    func save(model: EventModel)
    func update(model: EventModel)
}

class StorageManager: StorageManagerProtocol {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EventLists")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var backgroundContext = persistentContainer.newBackgroundContext()
    
    func checkIfExisted(model: EventModel, completion: (Result<Bool, StorageError>) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedEvent")
        fetchRequest.predicate = NSPredicate(format: "id = %@", model.event.id)
        do {
            if let result = try backgroundContext.fetch(fetchRequest) as? [NSManagedObject] {
                print("====result=====")
                print("--\(!(result.isEmpty))")
                completion(.success(!(result.isEmpty)))
                return
            }
            print("----check false--")
            completion(.success(false))
        } catch {
            completion(.failure(StorageError.fetchFailed))
        }
    }
    
    func save(model: EventModel) {
        backgroundContext.perform {
            if let entity = NSEntityDescription.entity(forEntityName: "SavedEvent", in: self.backgroundContext) {
                let managedObject = NSManagedObject(entity: entity, insertInto: self.backgroundContext)
                
                managedObject.setValue(model.event.id, forKey: "id")
                managedObject.setValue(model.event.title, forKey: "title")
                managedObject.setValue(model.event.image, forKey: "image")
                managedObject.setValue(model.event.startDate, forKey: "date")
                
                if self.backgroundContext.hasChanges {
                    do {
                        try self.backgroundContext.save()
                    } catch {
                        let nserror = error as NSError
                        print("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                }
            }
        }
    }
    
    func update(model: EventModel) {
        
    }
    
    
}
