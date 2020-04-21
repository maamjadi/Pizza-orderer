//
//  OrderRepositoryImpl.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 20..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation
import Alamofire
import CoreData


class OrderRepository: NSObject {

    static let shared = OrderRepository()

    private var mainContext: NSManagedObjectContext!
    private var _order: OrderDataModel?

    private var orderObjectJSON: [String : Any]? {

        let pizzaDTOs = order.pizzas.compactMap({ $0.pizzaDTO })
        let drinkIds = order.drinks.compactMap({ $0.identifier })

        return OrderObjectDTO(pizzas: pizzaDTOs, drinks: drinkIds).dictionaryJson
    }

    var order: OrderDataModel {
        initializeOrder()
        return _order!
    }

    var savedOrder: OrderDataModel? {
        if let saveOrder = Order.getItem(context: mainContext) {
            return OrderDataModel(order: saveOrder)
        } else {
            return nil
        }
    }

    private override init() {
        let container = NSPersistentContainer.create(for: "PizzaOrderer")
        container.viewContext.automaticallyMergesChangesFromParent = true
        mainContext = container.viewContext
        super.init()
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
}
