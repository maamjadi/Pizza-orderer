//
//  ManagedObjectExtension.swift
//  Creator
//
//  Created by Amin Amjadi on 11/01/19.
//  Copyright © 2018 Amin Amjadi. All rights reserved.
//

import Foundation
import CoreData

enum Ordering {
    case asc, desc
}

extension NSManagedObject {

    class func cd_entityName() -> String {
        return String(describing: self)
    }

    class func cd_createFetchRequest<T: NSManagedObject>(predicate: NSPredicate? = nil)
        -> NSFetchRequest<T> {

        let fetchRequest = NSFetchRequest<T>(entityName: cd_entityName())
        fetchRequest.predicate = predicate

        return fetchRequest
    }

    class func cd_execute<T: NSManagedObject>(
        fetchRequest: NSFetchRequest<T>,
        inContext context: NSManagedObjectContext) -> [T]? {

        var result: [T]?

        context.performAndWait {
            do {
                try result = context.fetch(fetchRequest)
            } catch let error {
                print("CoreData", "Fetch error: \(error)")
            }
        }

        return result
    }

    class func cd_new<T: NSManagedObject>(inContext context: NSManagedObjectContext) -> T? {
        return NSEntityDescription.insertNewObject(forEntityName: cd_entityName(), into: context) as? T
    }

    class func cd_findAll<T: NSManagedObject>(inContext context: NSManagedObjectContext,
                                              predicate: NSPredicate? = nil,
                                              sortedBy: [(String, Ordering)] = []) -> [T]? {

        let fetchRequest: NSFetchRequest<T> = cd_createFetchRequest(predicate: predicate)
        fetchRequest.sortDescriptors = []
        for (sortBy, ordering) in sortedBy {
            fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: sortBy, ascending: ordering == .asc))
        }
        return cd_execute(fetchRequest: fetchRequest, inContext: context)
    }

    class func cd_count(inContex context: NSManagedObjectContext,
                        predicate: NSPredicate? = nil) -> Int {
        let eName = String(describing: self)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: eName)
        request.predicate = predicate
        do {
            return try context.count(for: request)
        } catch {
            print("CoreData", "Fetch error: \(error)")
            return 0
        }
    }

    @discardableResult
    class func cd_delete(inContext context: NSManagedObjectContext, predicate: NSPredicate) -> Int {

        let fetchRequest = cd_createFetchRequest(predicate: predicate)
        fetchRequest.returnsObjectsAsFaults = true
        fetchRequest.includesPropertyValues = false

        var count = 0
        let objectsToDelete = cd_execute(fetchRequest: fetchRequest, inContext: context)
        objectsToDelete?.forEach({ object in
            context.delete(object)
            count += 1
        })

        return count
    }

    class func cd_fetchAll<T: NSManagedObject>(
        withPredicate predicate: NSPredicate?,
        sortedBy: [(String, Ordering)],
        delegate: NSFetchedResultsControllerDelegate?,
        faulting: Bool = true,
        context: NSManagedObjectContext) -> NSFetchedResultsController<T>? {

        let fetchRequest = cd_createFetchRequest(predicate: predicate)
        fetchRequest.returnsObjectsAsFaults = faulting
        fetchRequest.sortDescriptors = []
        for (sortBy, ordering) in sortedBy {
            fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: sortBy, ascending: ordering == .asc))
        }

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)

        fetchedResultsController.delegate = delegate

        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            print("CoreData", "Fetch error: \(error)")
        }

        return fetchedResultsController as? NSFetchedResultsController<T>
    }

    @discardableResult
    class func cd_deleteAll(inContext context: NSManagedObjectContext) -> Int {

        var count = 0
        let objectsToDelete = cd_findAll(inContext: context)
        objectsToDelete?.forEach({ object in
            context.delete(object)
            count += 1
        })

        return count
    }
}
