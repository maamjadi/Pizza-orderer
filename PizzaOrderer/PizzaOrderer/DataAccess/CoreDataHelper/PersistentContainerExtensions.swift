//
//  PersistentContainerExtensions.swift
//  Creator
//
//  Created by Amin Amjadi on 11/01/19.
//  Copyright © 2018 Amin Amjadi. All rights reserved.
//

import Foundation
import CoreData

extension NSPersistentContainer {
    class func create(for name: String) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: name)
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }

    var entityNames: [String] {
        return managedObjectModel.entities.map { (entity) -> String in
            entity.name!
        }
    }

    func clearAllData() {
        entityNames.forEach { entityName in
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

            let context = self.viewContext
            do {
                try context.execute(deleteRequest)
                try context.save()
                context.reset()
            } catch {
                print("Database", "There was an error clearing database")
            }
        }
    }
}
