//
//  OrderObjectDTO.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 08..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation

struct OrderObjectDTO: Codable {
    var pizzas: [PizzaDTO]

    ///list of drink IDs
    var drinks: [Int]
}
