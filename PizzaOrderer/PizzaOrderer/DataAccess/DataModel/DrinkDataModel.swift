//
//  DrinkDataModel.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 08..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation

struct DrinkDataModel: OrderableDataModel, Hashable, Equatable {
    var identifier: Int?
    var uniqueIdentifier: Int!
    var name: String
    var price: Double

    func hash(into hasher: inout Hasher) { hasher.combine(uniqueIdentifier) }

    static func == (lhs: Self, rhs: Self) -> Bool { lhs.hashValue == rhs.hashValue }
}
