//
//  Endpoints.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 08..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation

public enum Endpoints {

    public enum Url {

        static let baseUrl = "https://api.myjson.com/bins/"

        static let checkOut = "http://httpbin.org/post"

        enum PizzaOrderer {
            static let ingredients = baseUrl + "ozt3z"
            static let drinks = baseUrl + "150da7"
            static let pizzas = baseUrl + "dokm7"
        }
    }
}
