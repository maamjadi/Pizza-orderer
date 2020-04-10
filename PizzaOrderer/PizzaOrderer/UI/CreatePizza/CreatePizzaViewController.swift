//
//  CreatePizzaViewController.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 07..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import UIKit

class CreatePizzaViewController: UIViewController {

    @IBOutlet weak var pizzaBoardImageView: UIImageView!
    @IBOutlet weak var pizzaImageView: UIImageView!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    private let dataRepository = DataRepositoryImpl.dataRepository
    private let cellIdentifier = "ingredientCell"
    private let showCartSegue = "showCart"
    private let buttonTitleFormatText = "ADD TO CART ($%@)"

    private var ingredients = [IngredientDTO]() { didSet { tableView.reloadData() } }

    var pizzaDataModel: PizzaDataModel!
    var isCustomPizza = false

    override var prefersStatusBarHidden: Bool { StatusBarVisibility.shouldHide }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        loadIngredients()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setButtonPrice()

        navigationItem.title = pizzaDataModel.ingredients.isEmpty ? "CREATE A PIZZA" : pizzaDataModel.name.uppercased()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        dataRepository.saveOrderToPersistentStore()
    }

    private func setupViews() {
        tableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = .white
    }

    private func setButtonPrice() {
        addToCartButton.setTitle(String(format: buttonTitleFormatText, String(pizzaDataModel.totalPrice)), for: .normal)
    }

    private func loadIngredients() {

        dataRepository.getIngredients { [weak self] (ingredientsDTO, error) in

            if let ingredientsDTO = ingredientsDTO {
                self?.ingredients = ingredientsDTO.ingredients
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    @IBAction func addToCartAction(_ sender: Any) {
        dataRepository.addOrder(pizza: pizzaDataModel)
        showAlertDialog()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension CreatePizzaViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { ingredients.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? ItemTableViewCell else { return UITableViewCell() }

        let ingredient = ingredients[indexPath.row]
        cell.ingredient = ingredient
        cell.itemImageView.isHidden = !pizzaDataModel.ingredients.contains(ingredient)
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let cell = tableView.cellForRow(at: indexPath) as? ItemTableViewCell,
            let ingredient = cell.ingredient else { return }
        
        let ingredientExist = pizzaDataModel.ingredients.contains(ingredient)

        cell.itemImageView.isHidden = ingredientExist

        if ingredientExist {
            pizzaDataModel.ingredients.removeAll(where: { $0.identifier == ingredient.identifier })
        } else {
            pizzaDataModel.ingredients.append(ingredient)
        }

        setButtonPrice()
    }
}
