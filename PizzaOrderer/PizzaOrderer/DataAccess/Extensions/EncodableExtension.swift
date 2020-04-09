//
//  EncodableExtension.swift
//  PizzaOrderer
//
//  Created by Amin Amjadi on 2020. 04. 08..
//  Copyright © 2020. Amin Amjadi. All rights reserved.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }

    var dictionaryJson: [String : Any]? {
      let encoder = JSONEncoder()
      return (try? JSONSerialization.jsonObject(with: encoder.encode(self), options: .allowFragments)) as? [String: Any]
    }
}
