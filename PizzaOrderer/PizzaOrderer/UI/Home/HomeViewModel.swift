//
//  HomeViewModel.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 20..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation

class HomeViewModel: AppMainViewModel<HomeDelegateImpl> {

    private let dataFetcherRepository = DataFetcherRepository.shared
    private let orderRepository = OrderRepository.shared

    var basePrice: Double { dataFetcherRepository.basePrice }

    func loadPizzas() {

        dataFetcherRepository.getPizzas { [weak self] (pizzasDataModel, error) in

            if let pizzasDataModel = pizzasDataModel {
                self?.delegate?.data = pizzasDataModel
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func initializeOrder() { orderRepository.initializeOrder() }

    func addOrder(pizza: PizzaDataModel) { orderRepository.addOrder(pizza: pizza) }
}
