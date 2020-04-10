//
//  Pizza+CoreDataProperties.swift
//  
//
//  Created by Amin Amjadi on 2020. 04. 08..
//
//

import Foundation
import CoreData


extension Pizza {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pizza> {
        return NSFetchRequest<Pizza>(entityName: "Pizza")
    }

    @NSManaged public var identifier: Int64
    @NSManaged public var name: String
    @NSManaged public var price: Double
    @NSManaged public var order: Order?
}
