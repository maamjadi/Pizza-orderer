//
//  DrinksDTO.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 08..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation


struct DrinkDTO: Codable {
    var identifier: Int
    var name: String
    var price: Double

    var drinkDataModel: DrinkDataModel { DrinkDataModel(name: name, price: price) }

    public enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case price
    }
}
