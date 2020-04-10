//
//  ItemTableViewCell.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 07..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import UIKit
import Kingfisher

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    var ingredient: IngredientDTO? {
        didSet {
            guard let ingredient = ingredient else { return }

            titleLabel.text = ingredient.name
            set(price: ingredient.price)
            itemImageView.image = UIImage(systemName: "checkmark")
        }
    }

    var drink: DrinkDTO? {
        didSet {
            guard let drink = drink else { return }

            titleLabel.text = drink.name
            set(price: drink.price)
            itemImageView.image = UIImage(systemName: "plus")
        }
    }

    var checkoutItem: (name: String, price: Double, uniqueIdentifier: Int?)? {
        didSet {
            guard let item = checkoutItem else { return }

            let identifierExist = item.uniqueIdentifier == nil

            titleLabel.text = item.name
            set(price: item.price)
            itemImageView.image = UIImage(systemName: "multiply")
            itemImageView.isHidden = identifierExist

            titleLabel.font = UIFont.systemFont(ofSize: 17, weight: (identifierExist ? .bold : .regular))
            priceLabel.font = UIFont.systemFont(ofSize: 17, weight: (identifierExist ? .bold : .regular))
        }
    }

    private func set(price: Double) { priceLabel.text = "$" + String(price) }
}
