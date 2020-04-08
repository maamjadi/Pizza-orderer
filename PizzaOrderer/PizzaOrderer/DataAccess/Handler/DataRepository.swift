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

    func getPizzas(_ completionHandler: @escaping DataCompletionHandler<[PizzaDataModel]>)
    func getDrinks(_ completionHandler: @escaping DataCompletionHandler<DrinksDTO>)
    func getIngredients(_ completionHandler: @escaping DataCompletionHandler<IngredientsDTO>)
    func addOrder(drink: DrinkDataModel)
    func addOrder(pizza: PizzaDataModel)
    func requestOrder(_ completionHandler: DataCompletionHandler<Void>)
}
