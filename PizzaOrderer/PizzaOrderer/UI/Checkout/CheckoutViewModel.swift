//
//  CheckoutViewModel.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 20..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation


class CheckoutViewModel: AppMainViewModel<CheckoutDelegateImpl> {

    private let orderRepository = OrderRepository.shared

    var order: OrderDataModel! {
        didSet {
            delegate?.data = order.pizzas + order.drinks
        }
    }
    var pizzas: [PizzaDataModel] { order.pizzas }
    var drinks: [DrinkDataModel] { order.drinks }

    func updateOrder() { order = orderRepository.order }
    func saveOrder() { orderRepository.saveOrderToPersistentStore() }

    func removeOrder(drinkIdentifier: Int) {
        orderRepository.removeOrder(drinkIdentifier: drinkIdentifier)
    }

    func removeOrder(pizzaIdentifier: Int) {
        orderRepository.removeOrder(pizzaIdentifier: pizzaIdentifier)
    }

    func sendOrderRequest() {
        orderRepository.requestOrder { _, error in
            if let error = error { print(error.localizedDescription) }
        }
    }
}
