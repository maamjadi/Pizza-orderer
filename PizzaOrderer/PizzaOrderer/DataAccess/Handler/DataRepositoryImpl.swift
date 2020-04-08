//
//  DataRepositoryImpl.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 08..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation
import Alamofire

class DataRepositoryImpl: DataRepository {

    static let dataRepository: DataRepository = DataRepositoryImpl()

    private init() {}

    var drinks: DrinksDTO?
    var ingredients: IngredientsDTO?
    var pizzas: [PizzaDataModel]?
    var order: OrderDataModel?

    func getPizzas(_ completionHandler: @escaping DataCompletionHandler<[PizzaDataModel]>) {

        getIngredients { [weak self] (ingredients, error) in

            if let error = error {
                completionHandler(nil, error)
            } else if let ingredients = ingredients {
                if let pizzas = self?.pizzas {
                    completionHandler(pizzas, nil)
                } else {
                    let url = Endpoints.Url.PizzaOrderer.pizzas

                    let fetchDataCompletionHandler: DataCompletionHandler<PizzasDTO> = { result, error in
                        if let error = error {
                            completionHandler(nil, error)
                        } else if let result = result {

                            let pizzas = result.pizzas.map({ PizzaDataModel(pizzaDTO: $0, ingredientsDTO: ingredients) })
                            self?.pizzas = pizzas
                            completionHandler(pizzas, nil)
                        } else {
                            let error = NSError(domain: "customError", code: 1, userInfo: ["description": "value could not be found"])
                            completionHandler(nil, error)
                        }
                    }

                    self?.fetchData(from: url, completionHandler: fetchDataCompletionHandler, valueSetCompletion: nil)
                }
            }
        }
    }

    func getDrinks(_ completionHandler: @escaping DataCompletionHandler<DrinksDTO>) {
        if let drinks = drinks {
            completionHandler(drinks, nil)
        } else {
            let url = Endpoints.Url.PizzaOrderer.drinks
            fetchData(from: url, completionHandler: completionHandler) { [weak self] value in
                self?.drinks = value
            }
        }
    }

    func getIngredients(_ completionHandler: @escaping DataCompletionHandler<IngredientsDTO>) {
        if let ingredients = ingredients {
            completionHandler(ingredients, nil)
        } else {
            let url = Endpoints.Url.PizzaOrderer.ingredients
            fetchData(from: url, completionHandler: completionHandler) { [weak self] value in
                self?.ingredients = value
            }
        }
    }

    func addOrder(drink: DrinkDataModel) { order?.drinks.append(drink) }

    func addOrder(pizza: PizzaDataModel) { order?.pizzas.append(pizza) }

    func requestOrder(_ completionHandler: DataCompletionHandler<Void>) {
        
    }

    private func fetchData<T>(from url: String,
                      completionHandler: @escaping DataCompletionHandler<T>,
                      valueSetCompletion: ((T) -> Void)?) where T: Decodable {

        AF.request(url, method: .get).responseDecodable(of: T.self, completionHandler: { response in
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
