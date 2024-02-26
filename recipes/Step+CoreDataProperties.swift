//
//  Step+CoreDataProperties.swift
//  
//
//  Created by Gemma Emery on 2/11/24.
//
//

import Foundation
import CoreData


extension Step {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Step> {
        return NSFetchRequest<Step>(entityName: "Step")
    }

    @NSManaged public var number: Int32
    @NSManaged public var body: String?

}
