//
//  OrderableDataModel.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 09..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation

protocol OrderableDataModel {
    var uniqueIdentifier: Int! { get set }
    var name: String { get set }
}
