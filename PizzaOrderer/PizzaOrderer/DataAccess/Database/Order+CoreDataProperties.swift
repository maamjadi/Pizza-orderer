//
//  Order+CoreDataProperties.swift
//  
//
//  Created by Amin Amjadi on 2020. 04. 08..
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var pizzas: Set<Pizza>
    @NSManaged public var drinks: Set<Drink>

}

// MARK: Generated accessors for pizzas
extension Order {

    @objc(addPizzasObject:)
    @NSManaged public func addToPizzas(_ value: Pizza)

    @objc(removePizzasObject:)
    @NSManaged public func removeFromPizzas(_ value: Pizza)

    @objc(addPizzas:)
    @NSManaged public func addToPizzas(_ values: Set<Pizza>)

    @objc(removePizzas:)
    @NSManaged public func removeFromPizzas(_ values: Set<Pizza>)

}

// MARK: Generated accessors for drinks
extension Order {

    @objc(addDrinksObject:)
    @NSManaged public func addToDrinks(_ value: Drink)

    @objc(removeDrinksObject:)
    @NSManaged public func removeFromDrinks(_ value: Drink)

    @objc(addDrinks:)
    @NSManaged public func addToDrinks(_ values: Set<Drink>)

    @objc(removeDrinks:)
    @NSManaged public func removeFromDrinks(_ values: Set<Drink>)

}
