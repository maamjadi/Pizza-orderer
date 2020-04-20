//
//  Drink+CoreDataClass.swift
//  
//
//  Created by Amin Amjadi on 2020. 04. 08..
//
//

import Foundation
import CoreData

@objc(Drink)
public class Drink: NSManagedObject {

    class func getItem(with identifier: Int, context: NSManagedObjectContext) -> Drink? {
        return Drink.cd_findAll(inContext: context,
                                predicate: NSPredicate(format: "identifier == \(identifier)"))?.first
    }

    class func deleteItem(with identifier: Int, context: NSManagedObjectContext) {
        Drink.cd_delete(inContext: context,
                        predicate: NSPredicate(format: "identifier == \(identifier)"))
    }
    
    class func addOrUpdateDrink(from content: DrinkDataModel, context: NSManagedObjectContext) -> Drink? {

        let drink = Drink.getItem(with: content.uniqueIdentifier, context: context) ?? Drink.cd_new(inContext: context)

        drink?.identifier = Int64(content.uniqueIdentifier)
        drink?.name = content.name
        drink?.price = content.price

        return drink
    }
}
