//
//  AppMainTableViewController.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 20..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import UIKit

class AppMainTableViewController<T: AppMainDelegate, VM: AppMainViewModel<T>>: UITableViewController {

    private var _viewModel: VM!
    var viewModel: VM { _viewModel }

    var delegateImpl: T!

    override func viewDidLoad() {
        super.viewDidLoad()

        delegateImpl = T(onDataUpdated)
        _viewModel = VM(delegateImpl)
    }

    func onDataUpdated() { tableView.reloadData() }
}
