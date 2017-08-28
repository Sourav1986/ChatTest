//
//  Users+CoreDataProperties.swift
//  Chat test
//
//  Created by Sourav@Beas on 28/08/17.
//  Copyright © 2017 beas. All rights reserved.
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var name: String?
    @NSManaged public var username: String?
    @NSManaged public var password: String?

}
