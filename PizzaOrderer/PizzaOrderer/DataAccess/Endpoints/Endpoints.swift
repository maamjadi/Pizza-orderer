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

        static let baseUrl = "​http://next.json-generator.com/api/json/get/"

        static let checkOut = "http://httpbin.org/post"

        enum PizzaOrderer {
            static let ingredients = baseUrl + "EkTFDCdsG​"
            static let drinks = baseUrl + "N1mnOA_oz​"
            static let pizzas = baseUrl + "NybelGcjz"
        }
    }
}
