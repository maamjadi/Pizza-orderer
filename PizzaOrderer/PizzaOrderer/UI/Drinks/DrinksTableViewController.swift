//
//  DrinksTableViewController.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 07..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import UIKit

class DrinksTableViewController: UITableViewController {

    private let dataRepository = DataRepositoryImpl.dataRepository
    private let cellIdentifier = "drinksCell"

    private var drinks = [DrinkDTO]() { didSet { tableView.reloadData() } }

    override var prefersStatusBarHidden: Bool { StatusBarVisibility.shouldHide }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "DRINKS"
        view.backgroundColor = .white

        setupTableView()

        loadDrinks()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        dataRepository.saveOrderToPersistentStore()
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 44
        tableView.estimatedRowHeight = 0
    }

    private func loadDrinks() {
        dataRepository.getDrinks { [weak self] (drinksDTO, error) in

            if let drinksDTO = drinksDTO {
                self?.drinks = drinksDTO.drinks
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { drinks.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? ItemTableViewCell else {
                                                        return UITableViewCell()
        }

        cell.drink = drinks[indexPath.row]
        cell.selectionStyle = .none

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let cell = tableView.cellForRow(at: indexPath) as? ItemTableViewCell, let drink = cell.drink else { return }

        let drinkDataModel = DrinkDataModel(identifier: drink.identifier, name: drink.name, price: drink.price)
        dataRepository.addOrder(drink: drinkDataModel)
        showAlertDialog()
    }

}
