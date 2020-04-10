//
//  CoreDataHelper.swift
//  Creator
//
//  Created by Amin Amjadi on 11/01/19.
//  Copyright © 2018 Amin Amjadi. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {

    func cd_saveToPersistentStore() {
        performAndWait {
            if hasChanges {
                var saveResult = false
                defer {
                    if saveResult, let parent = self.parent {
                        parent.cd_saveToPersistentStore()
                    }
                }
                do {
                    try self.save()
                    saveResult = true
                } catch {
                    print("NSManagedObjectContext", "\(error.localizedDescription)")
                    if let error = error as NSError? {
                        print("NSManagedObjectContext", "\(error.userInfo)")
                    }
                    saveResult = false
                }
            }
        }
    }
}
