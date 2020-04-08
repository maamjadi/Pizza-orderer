//
//  IngredientsDTO.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 08..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation

struct IngredientsDTO: Codable {
    var ingredients: [IngredientDTO]
}

struct IngredientDTO: Codable {
    var identifier: Int
    var name: String
    var price: Double

    public enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case price
    }
}
