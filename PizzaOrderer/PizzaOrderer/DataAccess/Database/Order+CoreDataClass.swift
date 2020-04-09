//
//  Order+CoreDataClass.swift
//  
//
//  Created by Amin Amjadi on 2020. 04. 08..
//
//

import Foundation
import CoreData

@objc(Order)
public class Order: NSManagedObject {

    class func getItem(context: NSManagedObjectContext) -> Order? {
        return Order.cd_findAll(inContext: context)?.first
    }

    class func deleteItem(context: NSManagedObjectContext) {
        let order = getItem(context: context)

        order?.pizzas.forEach { context.delete($0) }
        order?.drinks.forEach { context.delete($0) }

        Order.cd_deleteAll(inContext: context)
    }

    @discardableResult
    class func addOrUpdateMovies(from content: OrderDataModel, context: NSManagedObjectContext) -> Order? {

        var order = getItem(context: context)

        if let order = order {
            order.pizzas.forEach { context.delete($0) }
            order.drinks.forEach { context.delete($0) }
        } else {
            order = Order.cd_new(inContext: context)
        }

        content.pizzas.forEach { pizzaDataModel in
            if let pizza = Pizza.addOrUpdatePizza(from: pizzaDataModel, context: context) {
                order?.addToPizzas(pizza)
            }
        }

        content.drinks.forEach { drinkDataModel in
            if let pizza = Drink.addOrUpdateDrink(from: drinkDataModel, context: context) {
                order?.addToDrinks(pizza)
            }
        }

        return order
    }
}
