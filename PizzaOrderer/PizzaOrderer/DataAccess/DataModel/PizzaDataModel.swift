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
    var basePrice: Double
    
    private var _totalPrice: Double?
    var price: Double { (_totalPrice ?? ingredients.map({ $0.price }).reduce(0, +)) + basePrice }

    var pizzaDTO: PizzaDTO {
        let ingredients = self.ingredients.map({ $0.identifier })
        return PizzaDTO(name: name, ingredients: ingredients, imageUrl: imageUrl)
    }

    init(name: String, totalPrice: Double, uniqueIdentifier: Int, basePrice: Double) {
        self.name = name
        self._totalPrice = totalPrice
        self.uniqueIdentifier = uniqueIdentifier
        self.ingredients = []
        self.basePrice = basePrice
    }

    init(pizzaDTO: PizzaDTO, ingredientsDTO: [IngredientDTO], basePrice: Double) {
        self.name = pizzaDTO.name
        self.ingredients = ingredientsDTO.filter({ pizzaDTO.ingredients.contains($0.identifier) })
        self.imageUrl = pizzaDTO.imageUrl
        self.basePrice = basePrice
    }

    func hash(into hasher: inout Hasher) { hasher.combine(uniqueIdentifier) }

    static func == (lhs: Self, rhs: Self) -> Bool { lhs.hashValue == rhs.hashValue }
}
