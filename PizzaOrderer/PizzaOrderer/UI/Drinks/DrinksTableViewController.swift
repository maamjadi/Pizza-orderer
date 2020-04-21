//
//  DrinksTableViewController.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 07..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import UIKit

class DrinksDelegateImpl: AppMainDelegate {

    typealias dataType = DrinkDTO

    private var dataUpdateListener: () -> Void

    var data = [DrinkDTO]() { didSet { dataUpdateListener() } }

    required init(_ listener: @escaping () -> Void) {
        self.dataUpdateListener = listener
    }
}

class DrinksTableViewController: AppMainTableViewController<DrinksDelegateImpl, DrinksViewModel> {

    private let cellIdentifier = "drinksCell"

    override var prefersStatusBarHidden: Bool { StatusBarVisibility.shouldHide }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "DRINKS"
        view.backgroundColor = .white

        setupTableView()

        viewModel.loadDrinks()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        viewModel.saveOrder()
    }

    private func setupTableView() {
        tableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 44
        tableView.estimatedRowHeight = 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { delegateImpl.data.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? ItemTableViewCell else {
                                                        return UITableViewCell()
        }

        cell.drink = delegateImpl.data[indexPath.row]
        cell.selectionStyle = .none

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let cell = tableView.cellForRow(at: indexPath) as? ItemTableViewCell, let drink = cell.drink else { return }

        let drinkDataModel = DrinkDataModel(identifier: drink.identifier, name: drink.name, price: drink.price)
        viewModel.addOrder(drinkDataModel)
        showAlertDialog()
    }

}
