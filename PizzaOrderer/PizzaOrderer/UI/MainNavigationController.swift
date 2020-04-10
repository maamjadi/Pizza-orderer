//
//  MainNavigationController.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 10..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override var prefersStatusBarHidden: Bool { StatusBarVisibility.shouldHide }

    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }
}
