//
//  Artist+CoreDataProperties.swift
//  Skillbox-M20
//
//  Created by Максим Морозов on 28.12.2023.
//
//

import Foundation
import CoreData


extension Artist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Artist> {
        return NSFetchRequest<Artist>(entityName: "Artist")
    }

    @NSManaged public var country: String?
    @NSManaged public var dateOfBith: Date?
    @NSManaged public var name: String?
    @NSManaged public var lastName: String?

}

extension Artist : Identifiable {

}
