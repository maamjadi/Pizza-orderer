//
//  CreatePizzaViewModel.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 20..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation


class CreatePizzaViewModel: AppMainViewModel<CreatePizzaDelegateImpl> {

    private let orderRepository = OrderRepository.shared
    private let dataFetcherRepository = DataFetcherRepository.shared

    func saveOrder() { orderRepository.saveOrderToPersistentStore() }

    func loadIngredients() {
        dataFetcherRepository.getIngredients { [weak self] (ingredientsDTO, error) in

            if let ingredientsDTO = ingredientsDTO {
                self?.delegate?.data = ingredientsDTO
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func addOrder(_ pizza: PizzaDataModel) { orderRepository.addOrder(pizza: pizza) }
}
