//
//  AlertView.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 09..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation
import SnapKit

class AlertView: UIView {

    lazy var titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {

        backgroundColor = UIColor(named: "red")

        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        titleLabel.text = "ADDED TO CART"

        addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
