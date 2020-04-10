//
//  PizzaOrdererTests.swift
//  PizzaOrdererTests
//
//  Created by Amin Amjadi on 2020. 04. 07..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import XCTest
@testable import PizzaOrderer

class PizzaOrdererTests: XCTestCase {

    let dataRepository = DataRepositoryImpl.dataRepository

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
        var dtoObject: DrinksDTO?

        dataRepository.getDrinks { dataModel, error in
            dtoObject = dataModel
            exp.fulfill()
        }

        waitForExpectations(timeout: 10)

        XCTAssertNotNil(dtoObject)
    }

    func testGetIngredients() {
        let exp = expectation(description: "getting the list of all the available Ingredients")
        var dtoObject: IngredientsDTO?

        dataRepository.getIngredients { dataModel, error in
            dtoObject = dataModel
            exp.fulfill()
        }

        waitForExpectations(timeout: 10)

        XCTAssertNotNil(dtoObject)
    }

    func testPizzaOrdersUniqueIdentifier() {
        addPizzas()

        let pizzas = dataRepository.order.pizzas

        XCTAssertTrue(!pizzas.isEmpty && pizzas.count == Set(pizzas).count)
    }

    func testDrinkOrdersUniqueIdentifier() {
        addDrinks()

        let drinks = dataRepository.order.drinks

        XCTAssertTrue(!drinks.isEmpty && drinks.count == Set(drinks).count)
    }

    func testRemovingDrinkOrders() {
        removeDrinks()

        XCTAssertTrue(dataRepository.order.drinks.isEmpty)
    }

    func testRemovingPizzaOrders() {
        removePizzas()

        XCTAssertTrue(dataRepository.order.pizzas.isEmpty)
    }

    private func removeDrinks() {
        dataRepository.order.drinks.forEach({ dataRepository.removeOrder(drinkIdentifier: $0.uniqueIdentifier) })
    }

    private func removePizzas() {
        dataRepository.order.pizzas.forEach({ dataRepository.removeOrder(pizzaIdentifier: $0.uniqueIdentifier) })
    }

    private func addPizzas() {
        let pizza0DTO = PizzaDTO(name: "Pizza0", ingredients: [], imageUrl: nil)
        let pizza0DataModel = PizzaDataModel(pizzaDTO: pizza0DTO, ingredientsDTO: nil)

        let pizza1DTO = PizzaDTO(name: "Pizza1", ingredients: [], imageUrl: nil)
        let pizza1DataModel = PizzaDataModel(pizzaDTO: pizza1DTO, ingredientsDTO: nil)

        let pizza2DTO = PizzaDTO(name: "Pizza2", ingredients: [], imageUrl: nil)
        let pizza2DataModel = PizzaDataModel(pizzaDTO: pizza2DTO, ingredientsDTO: nil)

        let pizza3DTO = PizzaDTO(name: "Pizza3", ingredients: [], imageUrl: nil)
        let pizza3DataModel = PizzaDataModel(pizzaDTO: pizza3DTO, ingredientsDTO: nil)

        let pizza4DTO = PizzaDTO(name: "Pizza4", ingredients: [], imageUrl: nil)
        let pizza4DataModel = PizzaDataModel(pizzaDTO: pizza4DTO, ingredientsDTO: nil)

        let pizza5DTO = PizzaDTO(name: "Pizza5", ingredients: [], imageUrl: nil)
        let pizza5DataModel = PizzaDataModel(pizzaDTO: pizza5DTO, ingredientsDTO: nil)

        dataRepository.addOrder(pizza: pizza0DataModel)
        dataRepository.addOrder(pizza: pizza1DataModel)
        dataRepository.addOrder(pizza: pizza2DataModel)
        dataRepository.addOrder(pizza: pizza3DataModel)
        dataRepository.addOrder(pizza: pizza4DataModel)
        dataRepository.addOrder(pizza: pizza5DataModel)
    }

    private func addDrinks() {
        let drink0DataModel = DrinkDataModel(identifier: nil, uniqueIdentifier: nil, name: "Drink0", price: 0.0)
        let drink1DataModel = DrinkDataModel(identifier: nil, uniqueIdentifier: nil, name: "Drink1", price: 0.0)
        let drink2DataModel = DrinkDataModel(identifier: nil, uniqueIdentifier: nil, name: "Drink2", price: 0.0)
        let drink3DataModel = DrinkDataModel(identifier: nil, uniqueIdentifier: nil, name: "Drink3", price: 0.0)
        let drink4DataModel = DrinkDataModel(identifier: nil, uniqueIdentifier: nil, name: "Drink4", price: 0.0)
        let drink5DataModel = DrinkDataModel(identifier: nil, uniqueIdentifier: nil, name: "Drink5", price: 0.0)
        let drink6DataModel = DrinkDataModel(identifier: nil, uniqueIdentifier: nil, name: "Drink6", price: 0.0)

        dataRepository.addOrder(drink: drink0DataModel)
        dataRepository.addOrder(drink: drink1DataModel)
        dataRepository.addOrder(drink: drink2DataModel)
        dataRepository.addOrder(drink: drink3DataModel)
        dataRepository.addOrder(drink: drink4DataModel)
        dataRepository.addOrder(drink: drink5DataModel)
        dataRepository.addOrder(drink: drink6DataModel)
    }

    func testSavingDataToCoreData() {
        var order = dataRepository.order

        if order.pizzas.isEmpty && order.drinks.isEmpty {
            addDrinks()
            addPizzas()
        }

        dataRepository.saveOrderToPersistentStore()
        let savedData =  dataRepository.savedOrder

        removeDrinks()
        removePizzas()

        order = dataRepository.order

        let condition = savedData != nil && savedData!.drinks.count != order.drinks.count && savedData!.pizzas.count != order.pizzas.count

        XCTAssertTrue(condition)
    }

    func testRequestOrder() {
        let exp = expectation(description: "requesting the cart orders")
        var hasError = false

        dataRepository.requestOrder { _, error in
            hasError = error != nil
            exp.fulfill()
        }

        waitForExpectations(timeout: 10)

        XCTAssertFalse(hasError)
    }
}
