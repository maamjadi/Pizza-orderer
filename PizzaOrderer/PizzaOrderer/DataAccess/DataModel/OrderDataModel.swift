//
//  OrderDataModel.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 08..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation

struct OrderDataModel {
    var basePizzaPrice: Double = 0.0
    var pizzas: [PizzaDataModel]
    var drinks: [DrinkDataModel]

    init(pizzas: [PizzaDataModel], drinks: [DrinkDataModel]) {
        self.pizzas = pizzas
        self.drinks = drinks
        basePizzaPrice = pizzas.first?.basePrice ?? 0
    }

    init(order: Order) {
        let pizzas = order.pizzas.map({ PizzaDataModel(name: $0.name,
                                                       totalPrice: $0.price,
                                                       uniqueIdentifier: Int($0.identifier),
                                                       basePrice: order.basePizzaPrice) })

        let drinks = order.drinks.map({ DrinkDataModel(uniqueIdentifier: Int($0.identifier),
                                                       name: $0.name,
                                                       price: $0.price) })

        self.pizzas = pizzas
        self.drinks = drinks
    }
}
