//
//  CreatePizzaViewController.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 07..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import UIKit
import Kingfisher

class CreatePizzaDelegateImpl: AppMainDelegate {

    typealias dataType = IngredientDTO

    private var dataUpdateListener: () -> Void

    var data = [IngredientDTO]() { didSet { dataUpdateListener() } }

    required init(_ listener: @escaping () -> Void) {
        self.dataUpdateListener = listener
    }
}

class CreatePizzaViewController: AppMainViewController<CreatePizzaDelegateImpl, CreatePizzaViewModel> {

    @IBOutlet weak var pizzaBoardImageView: UIImageView!
    @IBOutlet weak var pizzaImageView: UIImageView!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    private let cellIdentifier = "ingredientCell"
    private let showCartSegue = "showCart"
    private let buttonTitleFormatText = "ADD TO CART ($%@)"

    var pizzaDataModel: PizzaDataModel!
    var isCustomPizza = false

    override var prefersStatusBarHidden: Bool { StatusBarVisibility.shouldHide }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        viewModel.loadIngredients()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setButtonPrice()

        navigationItem.title = pizzaDataModel.ingredients.isEmpty ? "CREATE A PIZZA" : pizzaDataModel.name.uppercased()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        viewModel.saveOrder()
    }

    override func onDataUpdated() { tableView.reloadData() }

    private func setupViews() {
        tableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = .white

        if let imageUrl = pizzaDataModel.imageUrl {
            let url = URL(string: imageUrl)

            pizzaImageView.kf.setImage(with: url,
                                       placeholder: nil,
                                       options: [.transition(.fade(0.5))])
        }
    }

    private func setButtonPrice() {
        addToCartButton.setTitle(String(format: buttonTitleFormatText, String(pizzaDataModel.price)), for: .normal)
    }

    @IBAction func addToCartAction(_ sender: Any) {
        viewModel.addOrder(pizzaDataModel)
        showAlertDialog()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension CreatePizzaViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { delegateImpl.data.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? ItemTableViewCell else { return UITableViewCell() }

        let ingredient = delegateImpl.data[indexPath.row]
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
