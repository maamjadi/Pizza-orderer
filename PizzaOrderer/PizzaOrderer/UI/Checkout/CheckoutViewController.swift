//
//  CheckoutViewController.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 07..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import UIKit
import SnapKit

class CheckoutViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutButton: UIButton!

    private lazy var successView = UIView()

    private let dataRepository = DataRepositoryImpl.dataRepository
    private let cellIdentifier = "chechoutItemsCell"

    private var order: OrderDataModel! { didSet { tableView.reloadData() } }
    private var pizzas: [PizzaDataModel] { order.pizzas }
    private var drinks: [DrinkDataModel] { order.drinks }

    override var prefersStatusBarHidden: Bool { StatusBarVisibility.shouldHide }

    private enum CellDataType {
        case pizza, drink, total

        init(row: Int, pizzas: [OrderableDataModel], drinks: [OrderableDataModel]) {

            if row < pizzas.count && !pizzas.isEmpty {
                self = .pizza
            } else if row >= pizzas.count && row < (pizzas.count + drinks.count) && !drinks.isEmpty {
                self = .drink
            } else {
                self = .total
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self

        addSuccessView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        order = dataRepository.order
    }

    private func addSuccessView() {
        successView.backgroundColor = .white

        let thanksLabel = UILabel()
        thanksLabel.text = "Thank you\n for your order!"
        thanksLabel.numberOfLines = 2
        thanksLabel.textAlignment = .center
        thanksLabel.font = UIFont.italicSystemFont(ofSize: 34)
        thanksLabel.textColor = UIColor(named: "red")

        navigationController?.view.addSubview(successView)
        successView.addSubview(thanksLabel)

        let bottomAreaInset = (navigationController?.view.safeAreaInsets.bottom ?? 0) + 50

        successView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(bottomAreaInset)
        }

        thanksLabel.snp.makeConstraints({ $0.center.equalToSuperview() })

        successView.alpha = 0
    }
    
    @IBAction func checkoutAction(_ sender: Any) {

        dataRepository.requestOrder { _, error in

            if let error = error { print(error.localizedDescription) }
        }

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {

            self.successView.alpha = 1
            self.checkoutButton.alpha = 0

        }, completion: { [weak self] _ in

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.successView.removeFromSuperview()
                self?.navigationController?.popViewController(animated: true)
            }
        })
    }

    @IBAction func drinksNavigationBarButtonAction(_ sender: Any) {
        let newViewController = DrinksTableViewController()
        navigationController?.pushViewController(newViewController, animated: true)
    }
}

extension CheckoutViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = pizzas.count + drinks.count

        if !pizzas.isEmpty || !drinks.isEmpty {
            numberOfRows += 1
        }

        return numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? ItemTableViewCell else {
                                                        return UITableViewCell()
        }

        let row = indexPath.row
        let cellDataType = CellDataType(row: row, pizzas: pizzas, drinks: drinks)

        switch cellDataType {
        case .pizza:
            let pizza = pizzas[row]
            cell.checkoutItem = (name: pizza.name, price: pizza.totalPrice, uniqueIdentifier: pizza.uniqueIdentifier)

        case .drink:
            let drink = drinks[row - pizzas.count]
            cell.checkoutItem = (name: drink.name, price: drink.price, uniqueIdentifier: drink.uniqueIdentifier)

        case .total:
            var price = 0.0

            price = pizzas.map({ $0.totalPrice }).reduce(0, +)
            price += drinks.map({ $0.price }).reduce(0, +)

            cell.checkoutItem = (name: "TOTAL", price: price, uniqueIdentifier: nil)
        }

        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let cell = tableView.cellForRow(at: indexPath) as? ItemTableViewCell,
            let checkoutItem = cell.checkoutItem else { return }

        let cellDataType = CellDataType(row: indexPath.row, pizzas: pizzas, drinks: drinks)

        switch cellDataType {
        case .pizza:
            if let identifier = checkoutItem.uniqueIdentifier { dataRepository.removeOrder(pizzaIdentifier: identifier) }

        case .drink:
            if let identifier = checkoutItem.uniqueIdentifier { dataRepository.removeOrder(drinkIdentifier: identifier) }

        default:
            break
        }

        dataRepository.saveOrderToPersistentStore()
        order = dataRepository.order
    }
}
