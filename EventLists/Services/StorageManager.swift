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
    func retrieve(completion: (Result<[EventDetail], StorageError>) -> Void)
    func getFavoriteStatus(for event: Event, completion: (Result<Bool, StorageError>) -> Void)
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
                completion(.success(!(result.isEmpty)))
                return
            }
            completion(.success(false))
        } catch {
            completion(.failure(StorageError.checkExistFailed))
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
                managedObject.setValue(model.isFavorite, forKey: "isFavorite")
                
                self.saveContext()
            }
        }
    }
    
    func update(model: EventModel) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedEvent")
        fetchRequest.predicate = NSPredicate(format: "id = %@", model.event.id)
        do {
            if let eventObject = try backgroundContext.fetch(fetchRequest).first as? NSManagedObject {
                eventObject.setValue(model.event.title, forKey: "title")
                eventObject.setValue(model.event.image, forKey: "image")
                eventObject.setValue(model.event.startDate, forKey: "date")
                eventObject.setValue(model.isFavorite, forKey: "isFavorite")
                
                self.saveContext()
            }
        } catch let error{
            print("Update CoreData error \(error.localizedDescription)")
        }
    }
    
    func retrieve(completion: (Result<[EventDetail], StorageError>) -> Void) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedEvent")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do {
            let events = try backgroundContext.fetch(fetchRequest).compactMap { EventDetail($0) }
            completion(.success(events))
        } catch {
            completion(.failure(StorageError.retrieveFailed))
        }
    }
    
    func getFavoriteStatus(for event: Event, completion: (Result<Bool, StorageError>) -> Void) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedEvent")
        fetchRequest.predicate = NSPredicate(format: "id = %@", event.id)
        do {
            let events = try backgroundContext.fetch(fetchRequest).compactMap { EventDetail($0) }
            if let isFavorite = events.first?.isFavorite {
                completion(.success(isFavorite))
                return
            }
            // isFavorite data not exist means it's initial save
            completion(.success(false))

        } catch {
            completion(.failure(StorageError.getFavoriteStatusFailed))
        }
    }
    
    private func saveContext() {
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
