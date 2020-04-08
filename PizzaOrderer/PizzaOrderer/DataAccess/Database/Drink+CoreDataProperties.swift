//
//  Drink+CoreDataProperties.swift
//  
//
//  Created by Amin Amjadi on 2020. 04. 08..
//
//

import Foundation
import CoreData


extension Drink {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Drink> {
        return NSFetchRequest<Drink>(entityName: "Drink")
    }

    @NSManaged public var identifier: Int64
    @NSManaged public var name: String
    @NSManaged public var price: Double

}
