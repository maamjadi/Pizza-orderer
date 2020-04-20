//
//  AppMainViewModel.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 20..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation

class AppMainViewModel<T: AppMainDelegate> {
    weak var delegate: T?
    required init(_ delegate: T) { self.delegate = delegate }
}
