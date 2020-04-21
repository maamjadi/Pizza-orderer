//
//  HomeViewController.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 07..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import UIKit

class HomeDelegateImpl: AppMainDelegate {

    typealias dataType = PizzaDataModel

    private var dataUpdateListener: () -> Void

    var data = [PizzaDataModel]() { didSet { dataUpdateListener() } }

    required init(_ listener: @escaping () -> Void) {
        self.dataUpdateListener = listener
    }
}

class HomeViewController: AppMainTableViewController<HomeDelegateImpl, HomeViewModel> {

    private let cellIdentifier = "homeCell"
    private let createPizzaSegue = "createPizza"
    private let showCartSegue = "showCart"

    override var prefersStatusBarHidden: Bool { StatusBarVisibility.shouldHide }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "PizzaTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        view.backgroundColor = .white
        viewModel.loadPizzas()
    }

    @IBAction func cartNavigationButtonAction(_ sender: Any) {
        performSegue(withIdentifier: showCartSegue, sender: nil)
    }
    
    @IBAction func addNavigationButtonAction(_ sender: Any) {

        let pizzaDTO = PizzaDTO(name: "Custom Pizza", ingredients: [], imageUrl: nil)
        let customPizza = PizzaDataModel(pizzaDTO: pizzaDTO, ingredientsDTO: [], basePrice: viewModel.basePrice)

        performSegue(withIdentifier: createPizzaSegue, sender: customPizza)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { delegateImpl.data.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? PizzaTableViewCell else { return UITableViewCell() }

        cell.configure(delegateImpl.data[indexPath.row], actionListener: self)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: createPizzaSegue, sender: delegateImpl.data[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        viewModel.initializeOrder()

        if segue.identifier == createPizzaSegue {

            guard let createPizzaViewController = segue.destination as? CreatePizzaViewController,
                let pizzaDataModel = sender as? PizzaDataModel else { return }

            createPizzaViewController.pizzaDataModel = pizzaDataModel
        }
    }
}

extension HomeViewController: PizzaCellDelegate {

    func addToCart(_ pizzaDataModel: PizzaDataModel) {
        viewModel.addOrder(pizza: pizzaDataModel)
        showAlertDialog()
    }
}
