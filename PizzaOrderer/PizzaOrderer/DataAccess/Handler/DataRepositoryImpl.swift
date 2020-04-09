//
//  DataRepositoryImpl.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 08..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class DataRepositoryImpl: NSObject, DataRepository {

    static let dataRepository: DataRepository = DataRepositoryImpl()

    private let mainContext: NSManagedObjectContext

    private var drinks: DrinksDTO?
    private var ingredients: IngredientsDTO?
    private var pizzas: [PizzaDataModel]?
    private var _order: OrderDataModel?

    private var orderObjectJSON: [String : Any]? {

        let pizzaDTOs = order.pizzas.compactMap({ $0.pizzaDTO })
        let drinkIds = order.drinks.compactMap({ $0.identifier })

        return OrderObjectDTO(pizzas: pizzaDTOs, drinks: drinkIds).dictionaryJson
    }

    var order: OrderDataModel {
        return _order!
    }

    private override init() {
        let container = NSPersistentContainer.create(for: "PizzaOrderer")
        container.viewContext.automaticallyMergesChangesFromParent = true
        mainContext = container.viewContext
        super.init()
    }

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

                    self?.fetchData(from: url, mockedFile: "pizzas", completionHandler: fetchDataCompletionHandler, valueSetCompletion: nil)
                }
            }
        }
    }

    func getDrinks(_ completionHandler: @escaping DataCompletionHandler<DrinksDTO>) {
        if let drinks = drinks {
            completionHandler(drinks, nil)
        } else {
            let url = Endpoints.Url.PizzaOrderer.drinks
            fetchData(from: url, mockedFile: "drinks", completionHandler: completionHandler) { [weak self] value in
                self?.drinks = value
            }
        }
    }

    func getIngredients(_ completionHandler: @escaping DataCompletionHandler<IngredientsDTO>) {
        if let ingredients = ingredients {
            completionHandler(ingredients, nil)
        } else {
            let url = Endpoints.Url.PizzaOrderer.ingredients
            fetchData(from: url, mockedFile: "ingredients", completionHandler: completionHandler) { [weak self] value in
                self?.ingredients = value
            }
        }
    }

    func addOrder(drink: DrinkDataModel) {
        var drink = drink
        initializeOrder()
        drink.uniqueIdentifier = getUniqueIdentifier(for: drink, from: order.drinks)
        _order?.drinks.append(drink)
    }

    func addOrder(pizza: PizzaDataModel) {
        var pizza = pizza
        initializeOrder()
        pizza.uniqueIdentifier = getUniqueIdentifier(for: pizza, from: order.pizzas)
        _order?.pizzas.append(pizza)
    }

    func removeOrder(drinkIdentifier: Int) {
        _order?.drinks.removeAll(where: { $0.uniqueIdentifier == drinkIdentifier })
    }

    func removeOrder(pizzaIdentifier: Int) {
        _order?.pizzas.removeAll(where: { $0.uniqueIdentifier == pizzaIdentifier })
    }

    func saveOrderToPersistentStore() {
        Order.addOrUpdateMovies(from: self.order, context: mainContext)
        mainContext.cd_saveToPersistentStore()
    }

    func initializeOrder() {
        if _order == nil {
            if let saveOrder = Order.getItem(context: mainContext) {
                _order = OrderDataModel(order: saveOrder)
            } else {
                _order = OrderDataModel(pizzas: [], drinks: [])
            }
        }
    }

    func requestOrder(_ completionHandler: @escaping DataCompletionHandler<Void>) {

        let url = Endpoints.Url.checkOut

        AF.request(url, method: .post,
                   parameters: orderObjectJSON,
                   encoding: JSONEncoding.default).response { [weak self] dataResponse in

                    //checking for success http response code
                    if let responseCode = dataResponse.response?.statusCode, (200..<299).contains(responseCode) {
                        completionHandler((), nil)
                    } else {
                        completionHandler((), dataResponse.error)
                    }

                    guard let self = self else { return }

                    Order.deleteItem(context: self.mainContext)
                    self.mainContext.cd_saveToPersistentStore()

                    self._order = OrderDataModel(pizzas: [], drinks: [])
        }
    }

    private func getUniqueIdentifier(for item: OrderableDataModel, from list: [OrderableDataModel]) -> Int {
        let maxIdentifier = list.map({ $0.uniqueIdentifier }).max()
        return list.isEmpty ? 0 : ((maxIdentifier ?? 0) + 1)
    }

    private func fetchData<T>(from url: String,
                              mockedFile fileName: String,
                              completionHandler: @escaping DataCompletionHandler<T>,
                              valueSetCompletion: ((T) -> Void)?) where T: Decodable {

        AF.request(url, method: .get).responseDecodable(of: T.self, completionHandler: { [weak self] response in

            if response.error != nil {

                //loading the data from mocked data in case of error response

                self?.loadMockedData(fileName: fileName, completionHandler: completionHandler, valueSetCompletion: valueSetCompletion)

            } else if let value = response.value {

                completionHandler(value, nil)
                valueSetCompletion?(value)
            } else {

                let error = NSError(domain: "customError", code: 1, userInfo: ["description": "value could not be found"])
                completionHandler(nil, error)
            }
        })
    }

    private func loadMockedData<T>(fileName: String,
                                   completionHandler: @escaping DataCompletionHandler<T>,
                                   valueSetCompletion: ((T) -> Void)?) where T: Decodable {

        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {

            do {

                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)

                completionHandler(decodedData, nil)
                valueSetCompletion?(decodedData)

            } catch {
                completionHandler(nil, error)
            }
        }
    }
}
