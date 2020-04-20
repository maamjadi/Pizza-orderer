//
//  DataRepositoryImpl.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 08..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation
import Alamofire

typealias DataCompletionHandler<T> = ((_ data: T?, _ error: Error?) -> Void)

class DataFetcherRepository: NSObject {

    static let shared = DataFetcherRepository()

    private var drinks: [DrinkDTO]?
    private var ingredients: [IngredientDTO]?
    private var pizzas: [PizzaDataModel]?

    private override init() {}

    var basePrice: Double = 0.0

    func getPizzas(_ completionHandler: @escaping DataCompletionHandler<[PizzaDataModel]>) {

        getIngredients { [weak self] (ingredients, error) in

            if let error = error {

                completionHandler(nil, error)

            } else if let ingredients = ingredients {

                if let pizzas = self?.pizzas {

                    completionHandler(pizzas, nil)
                } else {

                    let url = Endpoints.Url.pizzas

                    let fetchDataCompletionHandler: DataCompletionHandler<PizzasDTO> = { result, error in
                        if let error = error {
                            completionHandler(nil, error)
                        } else if let result = result {

                            self?.basePrice = result.basePrice

                            let pizzas = result.pizzas.map({ PizzaDataModel(pizzaDTO: $0,
                                                                            ingredientsDTO: ingredients,
                                                                            basePrice: result.basePrice) })
                            self?.pizzas = pizzas
                            completionHandler(pizzas, nil)
                        } else {
                            let error = NSError(domain: "customError", code: 1, userInfo: ["description": "value could not be found"])
                            completionHandler(nil, error)
                        }
                    }

                    self?.fetchData(from: url, mockedFile: "pizzas", completionHandler: fetchDataCompletionHandler, valueSetCompletion: nil)
                }
            }
        }
    }

    func getDrinks(_ completionHandler: @escaping DataCompletionHandler<[DrinkDTO]>) {
        if let drinks = drinks {
            completionHandler(drinks, nil)
        } else {
            let url = Endpoints.Url.drinks
            fetchData(from: url, mockedFile: "drinks", completionHandler: completionHandler) { [weak self] value in
                self?.drinks = value
            }
        }
    }

    func getIngredients(_ completionHandler: @escaping DataCompletionHandler<[IngredientDTO]>) {
        if let ingredients = ingredients {
            completionHandler(ingredients, nil)
        } else {
            let url = Endpoints.Url.ingredients
            fetchData(from: url, mockedFile: "ingredients", completionHandler: completionHandler) { [weak self] value in
                self?.ingredients = value
            }
        }
    }

    private func fetchData<T>(from url: String,
                              mockedFile fileName: String,
                              completionHandler: @escaping DataCompletionHandler<T>,
                              valueSetCompletion: ((T) -> Void)?) where T: Decodable {

        AF.request(url).responseDecodable(of: T.self, completionHandler: { response in

            if let error = response.error {

                completionHandler(nil, error)

            } else if let value = response.value {

                completionHandler(value, nil)
                valueSetCompletion?(value)
            } else {

                let error = NSError(domain: "customError", code: 1, userInfo: ["description": "value could not be found"])
                completionHandler(nil, error)
            }
        })
    }
}
