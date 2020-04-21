//
//  Pizza+CoreDataClass.swift
//  
//
//  Created by Amin Amjadi on 2020. 04. 08..
//
//

import Foundation
import CoreData

@objc(Pizza)
public class Pizza: NSManagedObject {

    class func getItem(with identifier: Int, context: NSManagedObjectContext) -> Pizza? {
        return Pizza.cd_findAll(inContext: context,
                                predicate: NSPredicate(format: "identifier == \(identifier)"))?.first
    }

    class func deleteItem(with identifier: Int, context: NSManagedObjectContext) {
        Pizza.cd_delete(inContext: context,
                        predicate: NSPredicate(format: "identifier == \(identifier)"))
    }

    class func addOrUpdatePizza(from content: PizzaDataModel, context: NSManagedObjectContext) -> Pizza? {

        let pizza = Pizza.getItem(with: content.uniqueIdentifier, context: context) ?? Pizza.cd_new(inContext: context)

        pizza?.name = content.name
        pizza?.identifier = Int64(content.uniqueIdentifier)
        pizza?.price = content.price

        return pizza
    }
}
