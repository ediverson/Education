//
//  User+CoreDataProperties.swift
//  dadaya
//
//  Created by Антон Старков on 29.11.2020.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var complite: Bool

}

extension User : Identifiable {

}
