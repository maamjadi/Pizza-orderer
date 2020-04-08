//
//  PizzasDTO.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 08..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation

struct PizzasDTO: Codable {
    var pizzas: [PizzaDTO]
    var basePrice: Double
}

struct PizzaDTO: Codable {
    var name: String

    ///list of ingredient IDs
    var ingredients: [Int]
    var imageUrl: String?
}
