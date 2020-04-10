//
//  DataRepository.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 08..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation

typealias DataCompletionHandler<T> = ((_ data: T?, _ error: Error?) -> Void)

protocol DataRepository {

    var order: OrderDataModel { get }
    var savedOrder: OrderDataModel? { get }

    func getPizzas(_ completionHandler: @escaping DataCompletionHandler<[PizzaDataModel]>)
    func getDrinks(_ completionHandler: @escaping DataCompletionHandler<DrinksDTO>)
    func getIngredients(_ completionHandler: @escaping DataCompletionHandler<IngredientsDTO>)
    func addOrder(drink: DrinkDataModel)
    func addOrder(pizza: PizzaDataModel)
    func removeOrder(drinkIdentifier: Int)
    func removeOrder(pizzaIdentifier: Int)
    func saveOrderToPersistentStore()
    func initializeOrder()
    func requestOrder(_ completionHandler: @escaping DataCompletionHandler<Void>)
}
