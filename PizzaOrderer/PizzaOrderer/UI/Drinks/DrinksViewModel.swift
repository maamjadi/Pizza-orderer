//
//  DrinksViewModel.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 20..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation


class DrinksViewModel: AppMainViewModel<DrinksDelegateImpl> {

    private let orderRepository = OrderRepository.shared
    private let dataFetcherRepository = DataFetcherRepository.shared

    func saveOrder() { orderRepository.saveOrderToPersistentStore() }
    func addOrder(_ drink: DrinkDataModel) { orderRepository.addOrder(drink: drink) }

    func loadDrinks() {
        dataFetcherRepository.getDrinks { [weak self] (drinksDTO, error) in

            if let drinksDTO = drinksDTO {
                self?.delegate?.data = drinksDTO
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
