//
//  PizzaDataModel.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 08..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation

struct PizzaDataModel: OrderableDataModel, Hashable, Equatable {
    var uniqueIdentifier: Int!
    var name: String
    var ingredients: [IngredientDTO]
    var imageUrl: String?
    
    private var _totalPrice: Double?
    var totalPrice: Double { _totalPrice ?? ingredients.map({ $0.price }).reduce(0, +) }

    var pizzaDTO: PizzaDTO {
        let ingredients = self.ingredients.map({ $0.identifier })
        return PizzaDTO(name: name, ingredients: ingredients, imageUrl: imageUrl)
    }

    init(name: String, totalPrice: Double, uniqueIdentifier: Int) {
        self.name = name
        self._totalPrice = totalPrice
        self.uniqueIdentifier = uniqueIdentifier
        self.ingredients = []
    }

    init(pizzaDTO: PizzaDTO, ingredientsDTO: IngredientsDTO?) {
        self.name = pizzaDTO.name
        self.ingredients = ingredientsDTO?.ingredients.filter({ pizzaDTO.ingredients.contains($0.identifier) }) ?? []
        self.imageUrl = pizzaDTO.imageUrl
    }

    func hash(into hasher: inout Hasher) { hasher.combine(uniqueIdentifier) }

    static func == (lhs: Self, rhs: Self) -> Bool { lhs.hashValue == rhs.hashValue }
}
