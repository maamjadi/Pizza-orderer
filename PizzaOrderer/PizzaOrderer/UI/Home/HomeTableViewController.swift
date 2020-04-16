//
//  HomeViewController.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 07..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

    private let dataRepository = DataRepositoryImpl.dataRepository
    private let cellIdentifier = "homeCell"
    private let createPizzaSegue = "createPizza"
    private let showCartSegue = "showCart"

    private var pizzas = [PizzaDataModel]() { didSet { tableView.reloadData() } }

    override var prefersStatusBarHidden: Bool { StatusBarVisibility.shouldHide }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "PizzaTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        view.backgroundColor = .white

        //This is to fix the latest iOS (13.4) bug where the defined attributes from storyboard won't work
         if #available(iOS 13.0, *) {
            let titleColor = (UIColor(named: "red") ?? .red)
            let titleFont = UIFont.systemFont(ofSize: 17, weight: .heavy)
            navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: titleColor,
                                                                                          .font: titleFont]
         }

        loadPizzas()
    }

    private func loadPizzas() {

        dataRepository.getPizzas { [weak self] (pizzasDataModel, error) in

            if let pizzasDataModel = pizzasDataModel {
                self?.pizzas = pizzasDataModel
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    @IBAction func cartNavigationButtonAction(_ sender: Any) {
        performSegue(withIdentifier: showCartSegue, sender: nil)
    }
    
    @IBAction func addNavigationButtonAction(_ sender: Any) {

        let pizzaDTO = PizzaDTO(name: "Custom Pizza", ingredients: [], imageUrl: nil)
        let customPizza = PizzaDataModel(pizzaDTO: pizzaDTO, ingredientsDTO: nil)

        performSegue(withIdentifier: createPizzaSegue, sender: customPizza)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { pizzas.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? PizzaTableViewCell else { return UITableViewCell() }

        cell.configure(pizzas[indexPath.row], actionListener: self)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: createPizzaSegue, sender: pizzas[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        dataRepository.initializeOrder()

        if segue.identifier == createPizzaSegue {

            guard let createPizzaViewController = segue.destination as? CreatePizzaViewController,
                let pizzaDataModel = sender as? PizzaDataModel else { return }

            createPizzaViewController.pizzaDataModel = pizzaDataModel
        }
    }
}

extension HomeViewController: PizzaCellDelegate {

    func addToCart(_ pizzaDataModel: PizzaDataModel) {
        dataRepository.addOrder(pizza: pizzaDataModel)
        showAlertDialog()
    }
}
