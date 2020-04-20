//
//  PizzaOrdererTests.swift
//  PizzaOrdererTests
//
//  Created by Amin Amjadi on 2020. 04. 20..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import XCTest

class PizzaOrdererTests: XCTestCase {

    var dataRepository = DataFetcherRepository.shared
    var orderRepository = OrderRepository.shared

    override func tearDownWithError() throws {
        removeOrders()
    }

    func testGetPizzas() {
        let exp = expectation(description: "getting the list of all the available Pizzas")
        var dtoObject = [PizzaDataModel]()

        dataRepository.getPizzas { dataModel, error in
            dtoObject = dataModel ?? []
            exp.fulfill()
        }

        waitForExpectations(timeout: 5)

        XCTAssertFalse(dtoObject.isEmpty)
    }

    func testGetDrinks() {
        let exp = expectation(description: "getting the list of all the available Drinks")
        var dtoObject: [DrinkDTO]?

        dataRepository.getDrinks { dataModel, error in
            dtoObject = dataModel
            exp.fulfill()
        }

        waitForExpectations(timeout: 10)

        XCTAssertNotNil(dtoObject)
    }

    func testGetIngredients() {
        let exp = expectation(description: "getting the list of all the available Ingredients")
        var dtoObject: [IngredientDTO]?

        dataRepository.getIngredients { dataModel, error in
            dtoObject = dataModel
            exp.fulfill()
        }

        waitForExpectations(timeout: 10)

        XCTAssertNotNil(dtoObject)
    }

    func testPizzaOrdersUniqueIdentifier() {
        addPizzas()

        let pizzas = orderRepository.order.pizzas

        XCTAssertTrue(!pizzas.isEmpty && pizzas.count == Set(pizzas).count)
    }

    func testDrinkOrdersUniqueIdentifier() {
        addDrinks()

        let drinks = orderRepository.order.drinks

        XCTAssertTrue(!drinks.isEmpty && drinks.count == Set(drinks).count)
    }

    func testRemovingDrinkOrders() {
        removeDrinks()

        XCTAssertTrue(orderRepository.order.drinks.isEmpty)
    }

    func testRemovingPizzaOrders() {
        removePizzas()

        XCTAssertTrue(orderRepository.order.pizzas.isEmpty)
    }

    private func removeDrinks() {
        orderRepository.order.drinks.forEach({ orderRepository.removeOrder(drinkIdentifier: $0.uniqueIdentifier) })
    }

    private func removePizzas() {
        orderRepository.order.pizzas.forEach({ orderRepository.removeOrder(pizzaIdentifier: $0.uniqueIdentifier) })
    }

    private func removeOrders() {
        removeDrinks()
        removePizzas()
    }

    private func addPizzas() {
        let pizza0DTO = PizzaDTO(name: "Pizza0", ingredients: [], imageUrl: nil)
        let pizza0DataModel = PizzaDataModel(pizzaDTO: pizza0DTO, ingredientsDTO: [], basePrice: 0.0)

        let pizza1DTO = PizzaDTO(name: "Pizza1", ingredients: [], imageUrl: nil)
        let pizza1DataModel = PizzaDataModel(pizzaDTO: pizza1DTO, ingredientsDTO: [], basePrice: 0.0)

        let pizza2DTO = PizzaDTO(name: "Pizza2", ingredients: [], imageUrl: nil)
        let pizza2DataModel = PizzaDataModel(pizzaDTO: pizza2DTO, ingredientsDTO: [], basePrice: 0.0)

        let pizza3DTO = PizzaDTO(name: "Pizza3", ingredients: [], imageUrl: nil)
        let pizza3DataModel = PizzaDataModel(pizzaDTO: pizza3DTO, ingredientsDTO: [], basePrice: 0.0)

        let pizza4DTO = PizzaDTO(name: "Pizza4", ingredients: [], imageUrl: nil)
        let pizza4DataModel = PizzaDataModel(pizzaDTO: pizza4DTO, ingredientsDTO: [], basePrice: 0.0)

        let pizza5DTO = PizzaDTO(name: "Pizza5", ingredients: [], imageUrl: nil)
        let pizza5DataModel = PizzaDataModel(pizzaDTO: pizza5DTO, ingredientsDTO: [], basePrice: 0.0)

        orderRepository.addOrder(pizza: pizza0DataModel)
        orderRepository.addOrder(pizza: pizza1DataModel)
        orderRepository.addOrder(pizza: pizza2DataModel)
        orderRepository.addOrder(pizza: pizza3DataModel)
        orderRepository.addOrder(pizza: pizza4DataModel)
        orderRepository.addOrder(pizza: pizza5DataModel)
    }

    private func addDrinks() {
        let drink0DataModel = DrinkDataModel(identifier: nil, uniqueIdentifier: nil, name: "Drink0", price: 0.0)
        let drink1DataModel = DrinkDataModel(identifier: nil, uniqueIdentifier: nil, name: "Drink1", price: 0.0)
        let drink2DataModel = DrinkDataModel(identifier: nil, uniqueIdentifier: nil, name: "Drink2", price: 0.0)
        let drink3DataModel = DrinkDataModel(identifier: nil, uniqueIdentifier: nil, name: "Drink3", price: 0.0)
        let drink4DataModel = DrinkDataModel(identifier: nil, uniqueIdentifier: nil, name: "Drink4", price: 0.0)
        let drink5DataModel = DrinkDataModel(identifier: nil, uniqueIdentifier: nil, name: "Drink5", price: 0.0)
        let drink6DataModel = DrinkDataModel(identifier: nil, uniqueIdentifier: nil, name: "Drink6", price: 0.0)

        orderRepository.addOrder(drink: drink0DataModel)
        orderRepository.addOrder(drink: drink1DataModel)
        orderRepository.addOrder(drink: drink2DataModel)
        orderRepository.addOrder(drink: drink3DataModel)
        orderRepository.addOrder(drink: drink4DataModel)
        orderRepository.addOrder(drink: drink5DataModel)
        orderRepository.addOrder(drink: drink6DataModel)
    }

    func testSavingDataToCoreData() {
        var order = orderRepository.order

        if order.pizzas.isEmpty && order.drinks.isEmpty {
            addDrinks()
            addPizzas()
        }

        orderRepository.saveOrderToPersistentStore()
        let savedData =  orderRepository.savedOrder

        removeOrders()

        order = orderRepository.order

        let condition = savedData != nil && savedData!.drinks.count != order.drinks.count && savedData!.pizzas.count != order.pizzas.count

        XCTAssertTrue(condition)
    }

    func testRequestOrder() {
        let exp = expectation(description: "requesting the cart orders")
        var hasError = false

        orderRepository.requestOrder { _, error in
            hasError = error != nil
            exp.fulfill()
        }

        waitForExpectations(timeout: 10)

        XCTAssertFalse(hasError)
    }
}
