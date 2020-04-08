//
//  PizzaDataModel.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 08..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation

struct PizzaDataModel {
    var uniqueIdentifier: Int!
    var name: String
    var ingredients: [IngredientDTO]
    var imageUrl: String?
    var totalPrice: Double { ingredients.map({ $0.price }).reduce(0, +) }

    init(pizzaDTO: PizzaDTO, ingredientsDTO: IngredientsDTO) {
        self.name = pizzaDTO.name
        self.ingredients = ingredientsDTO.ingredients.filter({ pizzaDTO.ingredients.contains($0.identifier) })
        self.imageUrl = pizzaDTO.imageUrl
    }
}
